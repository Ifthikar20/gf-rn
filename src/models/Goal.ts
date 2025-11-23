/**
 * Goal model - mirrors iOS Goal struct
 */
import {v4 as uuidv4} from 'uuid';

export enum GoalCategory {
  MEDITATION = 'Meditation',
  AUDIO = 'Audio',
  VIDEO = 'Video',
  WELLNESS = 'Wellness',
  MINDFULNESS = 'Mindfulness',
  SLEEP = 'Sleep',
  FITNESS = 'Fitness',
  CUSTOM = 'Custom',
}

export const GoalCategoryIcons: Record<GoalCategory, string> = {
  [GoalCategory.MEDITATION]: 'brain',
  [GoalCategory.AUDIO]: 'headphones',
  [GoalCategory.VIDEO]: 'play-circle',
  [GoalCategory.WELLNESS]: 'heart',
  [GoalCategory.MINDFULNESS]: 'leaf',
  [GoalCategory.SLEEP]: 'moon-o',
  [GoalCategory.FITNESS]: 'male',
  [GoalCategory.CUSTOM]: 'star',
};

export const GoalCategoryColors: Record<GoalCategory, string> = {
  [GoalCategory.MEDITATION]: '#9333EA', // purple
  [GoalCategory.AUDIO]: '#3B82F6', // blue
  [GoalCategory.VIDEO]: '#EF4444', // red
  [GoalCategory.WELLNESS]: '#EC4899', // pink
  [GoalCategory.MINDFULNESS]: '#22C55E', // green
  [GoalCategory.SLEEP]: '#6366F1', // indigo
  [GoalCategory.FITNESS]: '#F97316', // orange
  [GoalCategory.CUSTOM]: '#EAB308', // yellow
};

export interface Goal {
  id: string;
  title: string;
  description: string;
  category: GoalCategory;
  targetValue: number;
  currentValue: number;
  unit: string;
  targetDate?: string;
  isCompleted: boolean;
  createdDate: string;
  completedDate?: string;
}

export const createGoal = (params: {
  title: string;
  description?: string;
  category?: GoalCategory;
  targetValue?: number;
  currentValue?: number;
  unit?: string;
  targetDate?: string;
}): Goal => ({
  id: uuidv4(),
  title: params.title,
  description: params.description || '',
  category: params.category || GoalCategory.WELLNESS,
  targetValue: params.targetValue || 1,
  currentValue: params.currentValue || 0,
  unit: params.unit || 'times',
  targetDate: params.targetDate,
  isCompleted: false,
  createdDate: new Date().toISOString(),
});

export const getProgress = (goal: Goal): number => {
  if (goal.targetValue <= 0) return 0;
  return Math.min(goal.currentValue / goal.targetValue, 1);
};

export const getProgressPercentage = (goal: Goal): number => {
  return Math.round(getProgress(goal) * 100);
};

export const getCategoryColor = (category: GoalCategory): string => {
  return GoalCategoryColors[category] || '#3B82F6';
};

export const getCategoryIcon = (category: GoalCategory): string => {
  return GoalCategoryIcons[category] || 'star';
};

// Sample goals for development/testing
export const sampleGoals: Goal[] = [
  createGoal({
    title: 'Meditate Daily',
    description: 'Complete 30 meditation sessions this month',
    category: GoalCategory.MEDITATION,
    targetValue: 30,
    currentValue: 12,
    unit: 'sessions',
  }),
  createGoal({
    title: 'Listen to Calming Audio',
    description: 'Listen to 10 hours of relaxing audio content',
    category: GoalCategory.AUDIO,
    targetValue: 10,
    currentValue: 4,
    unit: 'hours',
  }),
  createGoal({
    title: 'Watch Wellness Videos',
    description: 'Complete 5 wellness video courses',
    category: GoalCategory.VIDEO,
    targetValue: 5,
    currentValue: 2,
    unit: 'courses',
  }),
  createGoal({
    title: 'Improve Sleep',
    description: 'Use sleep content 20 times',
    category: GoalCategory.SLEEP,
    targetValue: 20,
    currentValue: 8,
    unit: 'nights',
  }),
];

export default Goal;
