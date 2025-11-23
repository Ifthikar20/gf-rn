import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { goalsApi } from '@services/api';
import {
  Goal,
  CreateGoalPayload,
  UpdateGoalPayload,
  UpdateGoalProgressPayload,
} from '@app-types/index';

const GOALS_KEYS = {
  all: ['goals'] as const,
  list: () => [...GOALS_KEYS.all, 'list'] as const,
  goalById: (id: string) => [...GOALS_KEYS.all, 'goal', id] as const,
  stats: () => [...GOALS_KEYS.all, 'stats'] as const,
  progress: (goalId: string) => [...GOALS_KEYS.all, 'progress', goalId] as const,
};

export const useGoals = () => {
  return useQuery({
    queryKey: GOALS_KEYS.list(),
    queryFn: () => goalsApi.getGoals(),
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
};

export const useGoalById = (id: string) => {
  return useQuery({
    queryKey: GOALS_KEYS.goalById(id),
    queryFn: () => goalsApi.getGoalById(id),
    enabled: !!id,
  });
};

export const useGoalStats = () => {
  return useQuery({
    queryKey: GOALS_KEYS.stats(),
    queryFn: () => goalsApi.getStats(),
    staleTime: 5 * 60 * 1000,
  });
};

export const useCreateGoal = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (payload: CreateGoalPayload) => goalsApi.createGoal(payload),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: GOALS_KEYS.list() });
      queryClient.invalidateQueries({ queryKey: GOALS_KEYS.stats() });
    },
  });
};

export const useUpdateGoal = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (payload: UpdateGoalPayload) => goalsApi.updateGoal(payload),
    onMutate: async (payload) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({ queryKey: GOALS_KEYS.goalById(payload.id) });

      // Get previous value
      const previousGoal = queryClient.getQueryData<Goal>(
        GOALS_KEYS.goalById(payload.id)
      );

      // Optimistically update goal
      if (previousGoal) {
        queryClient.setQueryData<Goal>(GOALS_KEYS.goalById(payload.id), {
          ...previousGoal,
          ...payload,
        });
      }

      // Also update in the list
      const previousGoals = queryClient.getQueryData<Goal[]>(GOALS_KEYS.list());
      if (previousGoals) {
        queryClient.setQueryData<Goal[]>(
          GOALS_KEYS.list(),
          previousGoals.map((goal) =>
            goal.id === payload.id ? { ...goal, ...payload } : goal
          )
        );
      }

      return { previousGoal, previousGoals };
    },
    onError: (err, payload, context) => {
      // Rollback on error
      if (context?.previousGoal) {
        queryClient.setQueryData(GOALS_KEYS.goalById(payload.id), context.previousGoal);
      }
      if (context?.previousGoals) {
        queryClient.setQueryData(GOALS_KEYS.list(), context.previousGoals);
      }
    },
    onSettled: (_, __, payload) => {
      queryClient.invalidateQueries({ queryKey: GOALS_KEYS.goalById(payload.id) });
      queryClient.invalidateQueries({ queryKey: GOALS_KEYS.list() });
      queryClient.invalidateQueries({ queryKey: GOALS_KEYS.stats() });
    },
  });
};

export const useDeleteGoal = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: string) => goalsApi.deleteGoal(id),
    onMutate: async (id) => {
      await queryClient.cancelQueries({ queryKey: GOALS_KEYS.list() });

      const previousGoals = queryClient.getQueryData<Goal[]>(GOALS_KEYS.list());

      if (previousGoals) {
        queryClient.setQueryData<Goal[]>(
          GOALS_KEYS.list(),
          previousGoals.filter((goal) => goal.id !== id)
        );
      }

      return { previousGoals };
    },
    onError: (err, id, context) => {
      if (context?.previousGoals) {
        queryClient.setQueryData(GOALS_KEYS.list(), context.previousGoals);
      }
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: GOALS_KEYS.list() });
      queryClient.invalidateQueries({ queryKey: GOALS_KEYS.stats() });
    },
  });
};

export const useUpdateGoalProgress = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (payload: UpdateGoalProgressPayload) => goalsApi.updateProgress(payload),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({
        queryKey: GOALS_KEYS.goalById(variables.goalId),
      });
      queryClient.invalidateQueries({
        queryKey: GOALS_KEYS.progress(variables.goalId),
      });
      queryClient.invalidateQueries({ queryKey: GOALS_KEYS.list() });
      queryClient.invalidateQueries({ queryKey: GOALS_KEYS.stats() });
    },
  });
};

export const useGoalProgressHistory = (goalId: string) => {
  return useQuery({
    queryKey: GOALS_KEYS.progress(goalId),
    queryFn: () => goalsApi.getProgressHistory(goalId),
    enabled: !!goalId,
  });
};
