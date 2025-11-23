/**
 * Goal service for managing goals via API with local caching
 * Mirrors iOS GoalService
 */

import {Endpoints} from '../config/Config';
import {Goal, sampleGoals} from '../models/Goal';
import networkService from './NetworkService';
import storageService, {StorageKey} from './StorageService';

// Request/Response types
interface GoalsResponse {
  goals: Goal[];
  total?: number;
  page?: number;
}

interface CreateGoalRequest {
  title: string;
  description: string;
  category: string;
  targetValue: number;
  unit: string;
  targetDate?: string;
}

interface UpdateGoalRequest {
  title: string;
  description: string;
  category: string;
  targetValue: number;
  currentValue: number;
  unit: string;
  targetDate?: string;
  isCompleted: boolean;
}

interface UpdateProgressRequest {
  increment: number;
}

interface CompleteGoalRequest {
  isCompleted: boolean;
}

export enum PendingChangeAction {
  CREATE = 'create',
  UPDATE = 'update',
  DELETE = 'delete',
  INCREMENT_PROGRESS = 'incrementProgress',
}

export interface PendingChange {
  id: string;
  action: PendingChangeAction;
  goalId: string;
  goal?: Goal;
  amount?: number;
  timestamp: string;
}

class GoalService {
  private static instance: GoalService;

  private constructor() {}

  static getInstance(): GoalService {
    if (!GoalService.instance) {
      GoalService.instance = new GoalService();
    }
    return GoalService.instance;
  }

  // Fetch all goals from server
  async fetchGoals(): Promise<Goal[]> {
    const response = await networkService.get<GoalsResponse>(Endpoints.goals);
    const goals = response.goals || [];

    // Cache locally
    await this.cacheGoals(goals);

    return goals;
  }

  // Get a single goal by ID
  async getGoal(id: string): Promise<Goal> {
    return networkService.get<Goal>(Endpoints.goal(id));
  }

  // Create a new goal
  async createGoal(goal: Goal): Promise<Goal> {
    const request: CreateGoalRequest = {
      title: goal.title,
      description: goal.description,
      category: goal.category,
      targetValue: goal.targetValue,
      unit: goal.unit,
      targetDate: goal.targetDate,
    };

    const response = await networkService.post<Goal, CreateGoalRequest>(
      Endpoints.goals,
      request,
    );

    // Update cache
    const cached = await this.getCachedGoals();
    cached.unshift(response);
    await this.cacheGoals(cached);

    return response;
  }

  // Update an existing goal
  async updateGoal(goal: Goal): Promise<Goal> {
    const request: UpdateGoalRequest = {
      title: goal.title,
      description: goal.description,
      category: goal.category,
      targetValue: goal.targetValue,
      currentValue: goal.currentValue,
      unit: goal.unit,
      targetDate: goal.targetDate,
      isCompleted: goal.isCompleted,
    };

    const response = await networkService.put<Goal, UpdateGoalRequest>(
      Endpoints.goal(goal.id),
      request,
    );

    // Update cache
    const cached = await this.getCachedGoals();
    const index = cached.findIndex(g => g.id === goal.id);
    if (index !== -1) {
      cached[index] = response;
      await this.cacheGoals(cached);
    }

    return response;
  }

  // Update goal progress (increment)
  async incrementProgress(goalId: string, amount: number = 1): Promise<Goal> {
    const request: UpdateProgressRequest = {increment: amount};

    const response = await networkService.patch<Goal, UpdateProgressRequest>(
      Endpoints.goalProgress(goalId),
      request,
    );

    // Update cache
    const cached = await this.getCachedGoals();
    const index = cached.findIndex(g => g.id === goalId);
    if (index !== -1) {
      cached[index] = response;
      await this.cacheGoals(cached);
    }

    return response;
  }

  // Delete a goal
  async deleteGoal(id: string): Promise<void> {
    await networkService.delete(Endpoints.goal(id));

    // Update cache
    const cached = await this.getCachedGoals();
    const filtered = cached.filter(g => g.id !== id);
    await this.cacheGoals(filtered);
  }

  // Mark goal as completed
  async completeGoal(id: string): Promise<Goal> {
    const request: CompleteGoalRequest = {isCompleted: true};

    const response = await networkService.patch<Goal, CompleteGoalRequest>(
      Endpoints.goal(id),
      request,
    );

    // Update cache
    const cached = await this.getCachedGoals();
    const index = cached.findIndex(g => g.id === id);
    if (index !== -1) {
      cached[index] = response;
      await this.cacheGoals(cached);
    }

    return response;
  }

  // Get cached goals (for offline support)
  async getCachedGoals(): Promise<Goal[]> {
    const cached = await storageService.getObject<Goal[]>(StorageKey.CACHED_GOALS);
    return cached || [];
  }

  // Cache goals locally
  async cacheGoals(goals: Goal[]): Promise<void> {
    await storageService.saveObject(StorageKey.CACHED_GOALS, goals);
  }

  // Clear local cache
  async clearCache(): Promise<void> {
    await storageService.delete(StorageKey.CACHED_GOALS);
  }

  // Get sample goals for development
  getSampleGoals(): Goal[] {
    return sampleGoals;
  }

  // Sync pending changes with server
  async syncPendingChanges(): Promise<void> {
    const pending = await this.getPendingChanges();

    for (const change of pending) {
      try {
        switch (change.action) {
          case PendingChangeAction.CREATE:
            if (change.goal) {
              await this.createGoal(change.goal);
            }
            break;
          case PendingChangeAction.UPDATE:
            if (change.goal) {
              await this.updateGoal(change.goal);
            }
            break;
          case PendingChangeAction.DELETE:
            await this.deleteGoal(change.goalId);
            break;
          case PendingChangeAction.INCREMENT_PROGRESS:
            await this.incrementProgress(change.goalId, change.amount || 1);
            break;
        }
      } catch (error) {
        console.log('Failed to sync change:', error);
        // Keep the change for retry
        continue;
      }
    }

    // Clear synced changes
    await storageService.delete(StorageKey.PENDING_CHANGES);
  }

  // Queue a change for later sync (offline mode)
  async queueChange(change: Omit<PendingChange, 'id' | 'timestamp'>): Promise<void> {
    const pending = await this.getPendingChanges();
    const newChange: PendingChange = {
      ...change,
      id: `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      timestamp: new Date().toISOString(),
    };
    pending.push(newChange);
    await storageService.saveObject(StorageKey.PENDING_CHANGES, pending);
  }

  // Get pending changes
  async getPendingChanges(): Promise<PendingChange[]> {
    const pending = await storageService.getObject<PendingChange[]>(
      StorageKey.PENDING_CHANGES,
    );
    return pending || [];
  }
}

export const goalService = GoalService.getInstance();
export default goalService;
