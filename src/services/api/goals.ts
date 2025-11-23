import { apiClient } from './client';
import {
  Goal,
  GoalStats,
  CreateGoalPayload,
  UpdateGoalPayload,
  UpdateGoalProgressPayload,
  GoalProgress,
} from '@app-types/index';

export const goalsApi = {
  /**
   * Get all goals
   */
  async getGoals(): Promise<Goal[]> {
    const response = await apiClient.get<Goal[]>('/goals');
    return response.data;
  },

  /**
   * Get a single goal by ID
   */
  async getGoalById(id: string): Promise<Goal> {
    const response = await apiClient.get<Goal>(`/goals/${id}`);
    return response.data;
  },

  /**
   * Create a new goal
   */
  async createGoal(payload: CreateGoalPayload): Promise<Goal> {
    const response = await apiClient.post<Goal>('/goals', payload);
    return response.data;
  },

  /**
   * Update an existing goal
   */
  async updateGoal(payload: UpdateGoalPayload): Promise<Goal> {
    const { id, ...updates } = payload;
    const response = await apiClient.patch<Goal>(`/goals/${id}`, updates);
    return response.data;
  },

  /**
   * Delete a goal
   */
  async deleteGoal(id: string): Promise<void> {
    await apiClient.delete(`/goals/${id}`);
  },

  /**
   * Update goal progress
   */
  async updateProgress(payload: UpdateGoalProgressPayload): Promise<GoalProgress> {
    const { goalId, ...data } = payload;
    const response = await apiClient.post<GoalProgress>(
      `/goals/${goalId}/progress`,
      data
    );
    return response.data;
  },

  /**
   * Get goal progress history
   */
  async getProgressHistory(goalId: string): Promise<GoalProgress[]> {
    const response = await apiClient.get<GoalProgress[]>(`/goals/${goalId}/progress`);
    return response.data;
  },

  /**
   * Get goal statistics
   */
  async getStats(): Promise<GoalStats> {
    const response = await apiClient.get<GoalStats>('/goals/stats');
    return response.data;
  },
};
