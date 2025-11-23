/**
 * Goal Progress Card Component
 * Mirrors iOS GoalProgressCard
 */

import React from 'react';
import {View, Text, StyleSheet} from 'react-native';
import Svg, {Circle} from 'react-native-svg';
import Icon from 'react-native-vector-icons/FontAwesome';
import {Colors} from '../../theme/colors';

interface Props {
  activeGoalsCount: number;
  completedGoalsCount: number;
  overallProgress: number;
  totalGoals: number;
}

const GoalProgressCard: React.FC<Props> = ({
  activeGoalsCount,
  completedGoalsCount,
  overallProgress,
  totalGoals,
}) => {
  const progressPercentage = Math.round(overallProgress * 100);

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <View>
          <Text style={styles.subtitle}>Overall Progress</Text>
          <Text style={styles.percentage}>{progressPercentage}%</Text>
        </View>
        <CircularProgress progress={overallProgress} />
      </View>

      <View style={styles.statsRow}>
        <StatBadge title="Active" value={activeGoalsCount} color={Colors.blue} />
        <StatBadge
          title="Completed"
          value={completedGoalsCount}
          color={Colors.success}
        />
        <StatBadge title="Total" value={totalGoals} color={Colors.purple} />
      </View>
    </View>
  );
};

// Circular Progress Component
interface CircularProgressProps {
  progress: number;
  size?: number;
}

const CircularProgress: React.FC<CircularProgressProps> = ({
  progress,
  size = 60,
}) => {
  const strokeWidth = 6;
  const radius = (size - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;
  const strokeDashoffset = circumference * (1 - progress);

  return (
    <View style={styles.circularContainer}>
      <Svg width={size} height={size}>
        {/* Background circle */}
        <Circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          stroke={Colors.border}
          strokeWidth={strokeWidth}
          fill="none"
        />
        {/* Progress circle */}
        <Circle
          cx={size / 2}
          cy={size / 2}
          r={radius}
          stroke={Colors.primary}
          strokeWidth={strokeWidth}
          fill="none"
          strokeDasharray={circumference}
          strokeDashoffset={strokeDashoffset}
          strokeLinecap="round"
          transform={`rotate(-90 ${size / 2} ${size / 2})`}
        />
      </Svg>
      <View style={styles.circularIcon}>
        <Icon name="bullseye" size={20} color={Colors.purple} />
      </View>
    </View>
  );
};

// Stat Badge Component
interface StatBadgeProps {
  title: string;
  value: number;
  color: string;
}

const StatBadge: React.FC<StatBadgeProps> = ({title, value, color}) => (
  <View style={styles.statBadge}>
    <Text style={[styles.statValue, {color}]}>{value}</Text>
    <Text style={styles.statTitle}>{title}</Text>
  </View>
);

const styles = StyleSheet.create({
  container: {
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 16,
    padding: 20,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 20,
  },
  subtitle: {
    fontSize: 14,
    color: Colors.textSecondary,
    marginBottom: 4,
  },
  percentage: {
    fontSize: 32,
    fontWeight: 'bold',
    color: Colors.text,
  },
  circularContainer: {
    position: 'relative',
    justifyContent: 'center',
    alignItems: 'center',
  },
  circularIcon: {
    position: 'absolute',
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  statBadge: {
    alignItems: 'center',
  },
  statValue: {
    fontSize: 22,
    fontWeight: 'bold',
  },
  statTitle: {
    fontSize: 12,
    color: Colors.textSecondary,
    marginTop: 4,
  },
});

export default GoalProgressCard;
