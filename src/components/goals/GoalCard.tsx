import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Image } from 'react-native';
import { Card } from '@components/common';
import { spacing, typography, borderRadius } from '@theme/index';
import { Goal } from '@app-types/index';
import { ProgressRing } from './ProgressRing';
import { useThemedColors } from '@/hooks/useThemedColors';

interface GoalCardProps {
  goal: Goal;
  onPress: () => void;
}

export const GoalCard: React.FC<GoalCardProps> = ({ goal, onPress }) => {
  const colors = useThemedColors();
  const progress = goal.target > 0 ? (goal.current / goal.target) * 100 : 0;
  const isMediaGoal = goal.type === 'video' || goal.type === 'audio';
  const showProgress = !isMediaGoal && goal.target > 0;

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

  const formatDuration = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    return `${mins} min`;
  };

  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.7}>
      <Card style={styles.card}>
        <View style={styles.content}>
          <View style={styles.header}>
            <View style={styles.titleContainer}>
              <View style={styles.titleTextContainer}>
                <Text style={[styles.title, { color: colors.text.primary }]} numberOfLines={1}>
                  {goal.title}
                </Text>
                <Text style={[styles.frequency, { color: colors.text.secondary }]}>
                  {goal.frequency} • {goal.streak} day streak
                </Text>
              </View>
            </View>

            <View
              style={[
                styles.statusBadge,
                { backgroundColor: getStatusColor(goal.status) },
              ]}
            >
              <Text style={[styles.statusText, { color: colors.text.inverse }]}>{goal.status}</Text>
            </View>
          </View>

          {isMediaGoal && goal.thumbnail && (
            <View style={styles.mediaContainer}>
              <Image source={{ uri: goal.thumbnail }} style={styles.thumbnail} />
              <View style={styles.mediaOverlay}>
                <Text style={[styles.mediaType, { color: colors.text.inverse }]}>{goal.type?.toUpperCase()}</Text>
                {goal.duration && (
                  <Text style={[styles.mediaDuration, { color: colors.text.inverse }]}>{formatDuration(goal.duration)}</Text>
                )}
              </View>
            </View>
          )}

          {showProgress && (
            <View style={styles.progressContainer}>
              <ProgressRing
                progress={progress}
                size={80}
                strokeWidth={8}
                color={goal.color || colors.primary.main}
              />

              <View style={styles.progressDetails}>
                <Text style={[styles.progressText, { color: colors.text.primary }]}>
                  {goal.current} / {goal.target} {goal.unit}
                </Text>
                <View style={[styles.progressBar, { backgroundColor: colors.neutral[200] }]}>
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
                <Text style={[styles.progressPercentage, { color: colors.text.secondary }]}>
                  {Math.round(progress)}% complete
                </Text>
              </View>
            </View>
          )}
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

  titleTextContainer: {
    flex: 1,
  },

  title: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
    marginBottom: spacing.xs / 2,
  },

  frequency: {
    fontSize: typography.fontSize.xs,
    textTransform: 'capitalize',
  },

  statusBadge: {
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs / 2,
    borderRadius: borderRadius.xl,
  },

  statusText: {
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.medium,
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
    marginBottom: spacing.xs,
  },

  progressBar: {
    height: 8,
    borderRadius: borderRadius.full,
    overflow: 'hidden',
    marginBottom: spacing.xs,
  },

  progressBarFill: {
    height: '100%',
    borderRadius: borderRadius.full,
  },

  progressPercentage: {
    fontSize: typography.fontSize.xs,
  },

  mediaContainer: {
    position: 'relative',
    width: '100%',
    height: 160,
    borderRadius: borderRadius.xl,
    overflow: 'hidden',
  },

  thumbnail: {
    width: '100%',
    height: '100%',
  },

  mediaOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: 'rgba(0, 0, 0, 0.6)',
    padding: spacing.sm,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },

  mediaType: {
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.semibold,
  },

  mediaDuration: {
    fontSize: typography.fontSize.xs,
  },
});
