/**
 * Goal Context
 * Provides goal state and actions with offline support
 */

import React, {
  createContext,
  useContext,
  useState,
  useEffect,
  useCallback,
  ReactNode,
} from 'react';
import NetInfo, {NetInfoState} from '@react-native-community/netinfo';
import {Goal, getProgress} from '../models/Goal';
import goalService, {PendingChangeAction} from '../services/GoalService';
import Config from '../config/Config';

export enum GoalFilter {
  ALL = 'all',
  ACTIVE = 'active',
  COMPLETED = 'completed',
}

interface GoalContextType {
  goals: Goal[];
  filteredGoals: Goal[];
  isLoading: boolean;
  isRefreshing: boolean;
  isOnline: boolean;
  selectedFilter: GoalFilter;
  errorMessage: string | null;
  activeGoalsCount: number;
  completedGoalsCount: number;
  overallProgress: number;
  setSelectedFilter: (filter: GoalFilter) => void;
  loadGoals: () => Promise<void>;
  refreshGoals: () => Promise<void>;
  addGoal: (goal: Goal) => Promise<void>;
  updateGoal: (goal: Goal) => Promise<void>;
  deleteGoal: (goal: Goal) => Promise<void>;
  incrementProgress: (goal: Goal, amount?: number) => Promise<void>;
  toggleCompletion: (goal: Goal) => Promise<void>;
  clearError: () => void;
  resetToSampleGoals: () => void;
}

const GoalContext = createContext<GoalContextType | undefined>(undefined);

interface GoalProviderProps {
  children: ReactNode;
}

export const GoalProvider: React.FC<GoalProviderProps> = ({children}) => {
  const [goals, setGoals] = useState<Goal[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [isOnline, setIsOnline] = useState(true);
  const [selectedFilter, setSelectedFilter] = useState<GoalFilter>(GoalFilter.ALL);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  // Network monitoring
  useEffect(() => {
    const unsubscribe = NetInfo.addEventListener((state: NetInfoState) => {
      const wasOffline = !isOnline;
      const nowOnline = state.isConnected ?? false;
      setIsOnline(nowOnline);

      // Sync when coming back online
      if (wasOffline && nowOnline) {
        syncPendingChanges();
      }
    });

    return () => unsubscribe();
  }, [isOnline]);

  // Initial load
  useEffect(() => {
    loadGoals();
  }, []);

  // Computed values
  const filteredGoals = React.useMemo(() => {
    switch (selectedFilter) {
      case GoalFilter.ACTIVE:
        return goals.filter(g => !g.isCompleted);
      case GoalFilter.COMPLETED:
        return goals.filter(g => g.isCompleted);
      default:
        return goals;
    }
  }, [goals, selectedFilter]);

  const activeGoalsCount = React.useMemo(
    () => goals.filter(g => !g.isCompleted).length,
    [goals],
  );

  const completedGoalsCount = React.useMemo(
    () => goals.filter(g => g.isCompleted).length,
    [goals],
  );

  const overallProgress = React.useMemo(() => {
    const activeGoals = goals.filter(g => !g.isCompleted);
    if (activeGoals.length === 0) return 0;
    const totalProgress = activeGoals.reduce((sum, g) => sum + getProgress(g), 0);
    return totalProgress / activeGoals.length;
  }, [goals]);

  const syncPendingChanges = async () => {
    try {
      await goalService.syncPendingChanges();
      await refreshGoals();
    } catch (error) {
      if (Config.isDebugLoggingEnabled) {
        console.log('Sync failed:', error);
      }
    }
  };

  const loadGoals = useCallback(async () => {
    setIsLoading(true);
    setErrorMessage(null);

    try {
      if (isOnline) {
        const fetchedGoals = await goalService.fetchGoals();
        setGoals(fetchedGoals);
      } else {
        // Offline - use cache
        const cachedGoals = await goalService.getCachedGoals();
        if (cachedGoals.length === 0) {
          // Use sample goals for demo
          setGoals(goalService.getSampleGoals());
        } else {
          setGoals(cachedGoals);
        }
      }
    } catch (error) {
      // Fall back to cache on error
      const cachedGoals = await goalService.getCachedGoals();
      if (cachedGoals.length === 0) {
        setGoals(goalService.getSampleGoals());
      } else {
        setGoals(cachedGoals);
      }
      handleError(error);
    } finally {
      setIsLoading(false);
    }
  }, [isOnline]);

  const refreshGoals = useCallback(async () => {
    if (!isOnline) {
      setErrorMessage("You're offline. Pull to refresh when connected.");
      return;
    }

    setIsRefreshing(true);
    setErrorMessage(null);

    try {
      const fetchedGoals = await goalService.fetchGoals();
      setGoals(fetchedGoals);
    } catch (error) {
      handleError(error);
    } finally {
      setIsRefreshing(false);
    }
  }, [isOnline]);

  const addGoal = useCallback(
    async (goal: Goal) => {
      // Optimistically add to local list
      setGoals(prev => [goal, ...prev]);

      if (isOnline) {
        try {
          const serverGoal = await goalService.createGoal(goal);
          // Update with server response
          setGoals(prev =>
            prev.map(g => (g.id === goal.id ? serverGoal : g)),
          );
        } catch (error) {
          handleError(error);
          // Queue for later sync
          await goalService.queueChange({
            action: PendingChangeAction.CREATE,
            goalId: goal.id,
            goal,
          });
        }
      } else {
        // Queue for sync when online
        await goalService.queueChange({
          action: PendingChangeAction.CREATE,
          goalId: goal.id,
          goal,
        });
      }
    },
    [isOnline],
  );

  const updateGoal = useCallback(
    async (goal: Goal) => {
      // Optimistically update local list
      setGoals(prev => prev.map(g => (g.id === goal.id ? goal : g)));

      if (isOnline) {
        try {
          const serverGoal = await goalService.updateGoal(goal);
          setGoals(prev =>
            prev.map(g => (g.id === goal.id ? serverGoal : g)),
          );
        } catch (error) {
          handleError(error);
          await goalService.queueChange({
            action: PendingChangeAction.UPDATE,
            goalId: goal.id,
            goal,
          });
        }
      } else {
        await goalService.queueChange({
          action: PendingChangeAction.UPDATE,
          goalId: goal.id,
          goal,
        });
      }
    },
    [isOnline],
  );

  const deleteGoal = useCallback(
    async (goal: Goal) => {
      // Optimistically remove from local list
      setGoals(prev => prev.filter(g => g.id !== goal.id));

      if (isOnline) {
        try {
          await goalService.deleteGoal(goal.id);
        } catch (error) {
          handleError(error);
          // Re-add if delete failed
          setGoals(prev => [goal, ...prev]);
          await goalService.queueChange({
            action: PendingChangeAction.DELETE,
            goalId: goal.id,
          });
        }
      } else {
        await goalService.queueChange({
          action: PendingChangeAction.DELETE,
          goalId: goal.id,
        });
      }
    },
    [isOnline],
  );

  const incrementProgress = useCallback(
    async (goal: Goal, amount: number = 1) => {
      // Optimistically update local state
      setGoals(prev =>
        prev.map(g => {
          if (g.id !== goal.id) return g;

          const newCurrentValue = Math.min(
            g.currentValue + amount,
            g.targetValue,
          );
          const isCompleted =
            newCurrentValue >= g.targetValue && !g.isCompleted;

          return {
            ...g,
            currentValue: newCurrentValue,
            isCompleted: isCompleted || g.isCompleted,
            completedDate: isCompleted
              ? new Date().toISOString()
              : g.completedDate,
          };
        }),
      );

      if (isOnline) {
        try {
          const serverGoal = await goalService.incrementProgress(goal.id, amount);
          setGoals(prev =>
            prev.map(g => (g.id === goal.id ? serverGoal : g)),
          );
        } catch (error) {
          handleError(error);
          await goalService.queueChange({
            action: PendingChangeAction.INCREMENT_PROGRESS,
            goalId: goal.id,
            amount,
          });
        }
      } else {
        await goalService.queueChange({
          action: PendingChangeAction.INCREMENT_PROGRESS,
          goalId: goal.id,
          amount,
        });
      }
    },
    [isOnline],
  );

  const toggleCompletion = useCallback(
    async (goal: Goal) => {
      const updatedGoal: Goal = {
        ...goal,
        isCompleted: !goal.isCompleted,
        completedDate: !goal.isCompleted
          ? new Date().toISOString()
          : undefined,
        currentValue: !goal.isCompleted ? goal.targetValue : goal.currentValue,
      };

      await updateGoal(updatedGoal);
    },
    [updateGoal],
  );

  const handleError = (error: unknown) => {
    if (error instanceof Error) {
      setErrorMessage(error.message);
    } else {
      setErrorMessage('An error occurred');
    }

    if (Config.isDebugLoggingEnabled) {
      console.log('GoalContext error:', error);
    }
  };

  const clearError = useCallback(() => {
    setErrorMessage(null);
  }, []);

  const resetToSampleGoals = useCallback(() => {
    setGoals(goalService.getSampleGoals());
    goalService.clearCache();
  }, []);

  const value: GoalContextType = {
    goals,
    filteredGoals,
    isLoading,
    isRefreshing,
    isOnline,
    selectedFilter,
    errorMessage,
    activeGoalsCount,
    completedGoalsCount,
    overallProgress,
    setSelectedFilter,
    loadGoals,
    refreshGoals,
    addGoal,
    updateGoal,
    deleteGoal,
    incrementProgress,
    toggleCompletion,
    clearError,
    resetToSampleGoals,
  };

  return <GoalContext.Provider value={value}>{children}</GoalContext.Provider>;
};

export const useGoals = (): GoalContextType => {
  const context = useContext(GoalContext);
  if (context === undefined) {
    throw new Error('useGoals must be used within a GoalProvider');
  }
  return context;
};

export default GoalContext;
