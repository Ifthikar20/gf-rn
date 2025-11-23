import React from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { RouteProp } from '@react-navigation/native';
import { useGoalById } from '@hooks/useGoals';
import { Button } from '@components/common';
import { ProgressRing } from '@components/goals';
import { colors, spacing, typography } from '@theme/index';


export const GoalDetailScreen = ({
  navigation,
  route,
}: {
  navigation: any;
  route: any;
}) => {
  const { id } = route.params;
  const { data: goal, isLoading } = useGoalById(id);

  if (isLoading) {
    return (
      <View style={styles.centered}>
        <Text style={styles.loadingText}>Loading...</Text>
      </View>
    );
  }

  if (!goal) {
    return (
      <View style={styles.centered}>
        <Text style={styles.errorText}>Goal not found</Text>
        <Button title="Go Back" onPress={() => navigation.goBack()} />
      </View>
    );
  }

  const progress = (goal.current / goal.target) * 100;

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <View style={styles.header}>
        {goal.icon && <Text style={styles.icon}>{goal.icon}</Text>}
        <Text style={styles.title}>{goal.title}</Text>
        <Text style={styles.description}>{goal.description}</Text>
      </View>

      <View style={styles.progressSection}>
        <ProgressRing
          progress={progress}
          size={150}
          strokeWidth={15}
          color={goal.color || colors.primary.main}
        />
        <Text style={styles.progressText}>
          {goal.current} / {goal.target} {goal.unit}
        </Text>
      </View>

      <View style={styles.statsGrid}>
        <View style={styles.statCard}>
          <Text style={styles.statLabel}>Frequency</Text>
          <Text style={styles.statValue}>{goal.frequency}</Text>
        </View>
        <View style={styles.statCard}>
          <Text style={styles.statLabel}>Streak</Text>
          <Text style={styles.statValue}>{goal.streak} days 🔥</Text>
        </View>
        <View style={styles.statCard}>
          <Text style={styles.statLabel}>Status</Text>
          <Text style={styles.statValue}>{goal.status}</Text>
        </View>
      </View>

      <Button title="Update Progress" onPress={() => {}} style={styles.button} />
      <Button
        title="Edit Goal"
        variant="outline"
        onPress={() => {}}
        style={styles.button}
      />
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background.primary,
  },

  content: {
    padding: spacing.screenPadding,
  },

  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: spacing.screenPadding,
  },

  loadingText: {
    fontSize: typography.fontSize.base,
    color: colors.text.secondary,
  },

  errorText: {
    fontSize: typography.fontSize.lg,
    color: colors.text.primary,
    marginBottom: spacing.lg,
  },

  header: {
    alignItems: 'center',
    marginBottom: spacing.xl,
  },

  icon: {
    fontSize: 64,
    marginBottom: spacing.md,
  },

  title: {
    fontSize: typography.fontSize['2xl'],
    fontWeight: typography.fontWeight.bold,
    color: colors.text.primary,
    textAlign: 'center',
    marginBottom: spacing.sm,
  },

  description: {
    fontSize: typography.fontSize.base,
    color: colors.text.secondary,
    textAlign: 'center',
  },

  progressSection: {
    alignItems: 'center',
    marginBottom: spacing.xl,
  },

  progressText: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.semibold,
    color: colors.text.primary,
    marginTop: spacing.lg,
  },

  statsGrid: {
    flexDirection: 'row',
    gap: spacing.md,
    marginBottom: spacing.xl,
  },

  statCard: {
    flex: 1,
    backgroundColor: colors.background.secondary,
    padding: spacing.md,
    borderRadius: 12,
    alignItems: 'center',
  },

  statLabel: {
    fontSize: typography.fontSize.xs,
    color: colors.text.secondary,
    marginBottom: spacing.xs,
  },

  statValue: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.semibold,
    color: colors.text.primary,
    textAlign: 'center',
    textTransform: 'capitalize',
  },

  button: {
    marginBottom: spacing.md,
  },
});
