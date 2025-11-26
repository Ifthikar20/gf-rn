import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Image } from 'react-native';
import { Card } from '@components/common';
import { spacing, typography, borderRadius } from '@theme/index';
import { Goal } from '@app-types/index';
import { useThemedColors } from '@/hooks/useThemedColors';

interface GoalCardProps {
  goal: Goal;
  onPress: () => void;
}

export const GoalCard: React.FC<GoalCardProps> = ({ goal, onPress }) => {
  const colors = useThemedColors();

  const getCategoryColor = (type?: string) => {
    switch (type) {
      case 'breath':
        return '#6366F1';
      case 'meditation':
        return '#F59E0B';
      case 'sleep-story':
        return '#A78BFA';
      case 'sleep-sound':
        return '#EC4899';
      default:
        return goal.color || colors.primary.main;
    }
  };

  const getCategoryLabel = (type?: string) => {
    switch (type) {
      case 'breath':
        return 'Breath';
      case 'meditation':
        return 'Meditation';
      case 'sleep-story':
        return 'Sleep story';
      case 'sleep-sound':
        return 'Relax music';
      default:
        return goal.description;
    }
  };

  const formatDuration = (seconds?: number) => {
    if (!seconds || seconds === 0) return '';
    const mins = Math.floor(seconds / 60);
    return `${mins} min`;
  };

  const categoryColor = getCategoryColor(goal.type);

  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.7}>
      <Card style={styles.card}>
        {/* Header: Icon + Category + Lock */}
        <View style={styles.cardHeader}>
          <View style={[styles.iconCircle, { backgroundColor: categoryColor }]}>
            <Text style={styles.iconText}>{goal.icon || '●'}</Text>
          </View>
          <Text style={[styles.categoryLabel, { color: colors.text.secondary }]}>
            {getCategoryLabel(goal.type)}
          </Text>
          {goal.isLocked && <Text style={styles.lockIcon}>🔒</Text>}
        </View>

        {/* Title */}
        <Text style={[styles.title, { color: colors.text.primary }]} numberOfLines={2}>
          {goal.title}
        </Text>

        {/* Duration */}
        {formatDuration(goal.duration) && (
          <Text style={[styles.duration, { color: colors.text.secondary }]}>
            {formatDuration(goal.duration)}
          </Text>
        )}

        {/* Thumbnail */}
        {goal.thumbnail && (
          <Image source={goal.thumbnail} style={styles.thumbnail} />
        )}

        {/* Completion Checkbox */}
        <View style={[styles.checkbox, { borderColor: colors.border.main }]}>
          <View style={styles.checkboxInner} />
        </View>
      </Card>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.md,
    marginHorizontal: spacing.screenPadding,
    position: 'relative',
    padding: spacing.md,
  },

  cardHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.sm,
  },

  iconCircle: {
    width: 32,
    height: 32,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: spacing.sm,
  },

  iconText: {
    fontSize: 16,
    color: '#FFFFFF',
  },

  categoryLabel: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.semibold,
    flex: 1,
  },

  lockIcon: {
    fontSize: 16,
    opacity: 0.8,
  },

  title: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.bold,
    marginBottom: spacing.xs,
  },

  duration: {
    fontSize: typography.fontSize.sm,
    marginBottom: spacing.sm,
  },

  thumbnail: {
    width: 120,
    height: 120,
    borderRadius: borderRadius.lg,
    alignSelf: 'flex-end',
    marginTop: spacing.sm,
  },

  checkbox: {
    position: 'absolute',
    left: spacing.md,
    bottom: spacing.md,
    width: 24,
    height: 24,
    borderRadius: 12,
    borderWidth: 2,
    backgroundColor: 'transparent',
    alignItems: 'center',
    justifyContent: 'center',
  },

  checkboxInner: {
    width: 12,
    height: 12,
    borderRadius: 6,
    backgroundColor: 'transparent',
  },
});
