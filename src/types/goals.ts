export type GoalStatus = 'active' | 'completed' | 'paused' | 'archived';

export type GoalFrequency = 'daily' | 'weekly' | 'monthly';

export interface Goal {
  id: string;
  title: string;
  description: string;
  status: GoalStatus;
  frequency: GoalFrequency;
  target: number;
  current: number;
  unit: string;
  icon?: string;
  color?: string;
  startDate: string;
  endDate?: string;
  reminders: boolean;
  reminderTime?: string;
  streak: number;
  createdAt: string;
  updatedAt: string;
}

export interface GoalProgress {
  goalId: string;
  date: string;
  value: number;
  notes?: string;
}

export interface GoalStats {
  totalGoals: number;
  activeGoals: number;
  completedGoals: number;
  totalProgress: number;
  averageStreak: number;
  longestStreak: number;
}

export interface CreateGoalPayload {
  title: string;
  description: string;
  frequency: GoalFrequency;
  target: number;
  unit: string;
  icon?: string;
  color?: string;
  endDate?: string;
  reminders: boolean;
  reminderTime?: string;
}

export interface UpdateGoalPayload {
  id: string;
  title?: string;
  description?: string;
  status?: GoalStatus;
  target?: number;
  reminders?: boolean;
  reminderTime?: string;
}

export interface UpdateGoalProgressPayload {
  goalId: string;
  value: number;
  notes?: string;
}
