/**
 * Goal Row Component
 * Mirrors iOS GoalRowView
 */

import React from 'react';
import {View, Text, StyleSheet, TouchableOpacity} from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import {
  Goal,
  getCategoryColor,
  getCategoryIcon,
  getProgress,
  getProgressPercentage,
} from '../../models/Goal';
import {Colors} from '../../theme/colors';

interface Props {
  goal: Goal;
  onPress: () => void;
  onIncrement: () => void;
  onToggleComplete: () => void;
  onDelete: () => void;
}

const GoalRowView: React.FC<Props> = ({
  goal,
  onPress,
  onIncrement,
}) => {
  const categoryColor = getCategoryColor(goal.category);
  const categoryIcon = getCategoryIcon(goal.category);
  const progress = getProgress(goal);
  const progressPercentage = getProgressPercentage(goal);

  return (
    <TouchableOpacity style={styles.container} onPress={onPress}>
      {/* Category Icon */}
      <View style={[styles.iconContainer, {backgroundColor: categoryColor + '20'}]}>
        <Icon name={categoryIcon} size={20} color={categoryColor} />
      </View>

      {/* Goal Info */}
      <View style={styles.content}>
        <View style={styles.titleRow}>
          <Text style={styles.title} numberOfLines={1}>
            {goal.title}
          </Text>
          {goal.isCompleted && (
            <Icon name="check-circle" size={14} color={Colors.success} />
          )}
        </View>

        {/* Progress Bar */}
        <View style={styles.progressContainer}>
          <View
            style={[
              styles.progressFill,
              {width: `${progress * 100}%`, backgroundColor: categoryColor},
            ]}
          />
        </View>

        <View style={styles.statsRow}>
          <Text style={styles.statsText}>
            {goal.currentValue}/{goal.targetValue} {goal.unit}
          </Text>
          <Text style={[styles.percentText, {color: categoryColor}]}>
            {progressPercentage}%
          </Text>
        </View>
      </View>

      {/* Quick Increment Button */}
      {!goal.isCompleted && (
        <TouchableOpacity
          style={styles.incrementButton}
          onPress={e => {
            e.stopPropagation();
            onIncrement();
          }}>
          <Icon name="plus-circle" size={26} color={categoryColor} />
        </TouchableOpacity>
      )}
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: Colors.background,
    borderBottomWidth: 1,
    borderBottomColor: Colors.border,
  },
  iconContainer: {
    width: 50,
    height: 50,
    borderRadius: 25,
    justifyContent: 'center',
    alignItems: 'center',
  },
  content: {
    flex: 1,
    marginLeft: 12,
    marginRight: 12,
  },
  titleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  title: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.text,
    flex: 1,
    marginRight: 8,
  },
  progressContainer: {
    height: 6,
    backgroundColor: Colors.border,
    borderRadius: 3,
    marginBottom: 6,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    borderRadius: 3,
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  statsText: {
    fontSize: 12,
    color: Colors.textSecondary,
  },
  percentText: {
    fontSize: 12,
    fontWeight: '600',
  },
  incrementButton: {
    padding: 4,
  },
});

export default GoalRowView;
