import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { Card } from '@components/common';
import { colors, spacing, typography } from '@theme/index';
import { Goal } from '@app-types/index';
import { ProgressRing } from './ProgressRing';

interface GoalCardProps {
  goal: Goal;
  onPress: () => void;
}

export const GoalCard: React.FC<GoalCardProps> = ({ goal, onPress }) => {
  const progress = (goal.current / goal.target) * 100;

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'active':
        return colors.success.main;
      case 'completed':
        return colors.primary.main;
      case 'paused':
        return colors.warning.main;
      case 'archived':
        return colors.neutral[400];
      default:
        return colors.neutral[400];
    }
  };

  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.7}>
      <Card style={styles.card}>
        <View style={styles.content}>
          <View style={styles.header}>
            <View style={styles.titleContainer}>
              {goal.icon && <Text style={styles.icon}>{goal.icon}</Text>}
              <View style={styles.titleTextContainer}>
                <Text style={styles.title} numberOfLines={1}>
                  {goal.title}
                </Text>
                <Text style={styles.frequency}>
                  {goal.frequency} • {goal.streak} day streak 🔥
                </Text>
              </View>
            </View>

            <View
              style={[
                styles.statusBadge,
                { backgroundColor: getStatusColor(goal.status) },
              ]}
            >
              <Text style={styles.statusText}>{goal.status}</Text>
            </View>
          </View>

          <View style={styles.progressContainer}>
            <ProgressRing
              progress={progress}
              size={80}
              strokeWidth={8}
              color={goal.color || colors.primary.main}
            />

            <View style={styles.progressDetails}>
              <Text style={styles.progressText}>
                {goal.current} / {goal.target} {goal.unit}
              </Text>
              <View style={styles.progressBar}>
                <View
                  style={[
                    styles.progressBarFill,
                    {
                      width: `${Math.min(progress, 100)}%`,
                      backgroundColor: goal.color || colors.primary.main,
                    },
                  ]}
                />
              </View>
              <Text style={styles.progressPercentage}>
                {Math.round(progress)}% complete
              </Text>
            </View>
          </View>
        </View>
      </Card>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.md,
  },

  content: {
    gap: spacing.md,
  },

  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
  },

  titleContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },

  icon: {
    fontSize: typography.fontSize['2xl'],
    marginRight: spacing.sm,
  },

  titleTextContainer: {
    flex: 1,
  },

  title: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
    color: colors.text.primary,
    marginBottom: spacing.xs / 2,
  },

  frequency: {
    fontSize: typography.fontSize.xs,
    color: colors.text.secondary,
    textTransform: 'capitalize',
  },

  statusBadge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs / 2,
    borderRadius: 12,
  },

  statusText: {
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.medium,
    color: colors.text.inverse,
    textTransform: 'capitalize',
  },

  progressContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.md,
  },

  progressDetails: {
    flex: 1,
  },

  progressText: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.medium,
    color: colors.text.primary,
    marginBottom: spacing.xs,
  },

  progressBar: {
    height: 8,
    backgroundColor: colors.neutral[200],
    borderRadius: 4,
    overflow: 'hidden',
    marginBottom: spacing.xs,
  },

  progressBarFill: {
    height: '100%',
    borderRadius: 4,
  },

  progressPercentage: {
    fontSize: typography.fontSize.xs,
    color: colors.text.secondary,
  },
});
