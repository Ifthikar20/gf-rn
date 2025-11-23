import React from 'react';
import { View, Text, StyleSheet, ScrollView } from 'react-native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { RouteProp } from '@react-navigation/native';
import { useGoalById } from '@hooks/useGoals';
import { Button, ThemedBackground } from '@components/common';
import { ProgressRing } from '@components/goals';
import { spacing, typography } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';


export const GoalDetailScreen = ({
  navigation,
  route,
}: {
  navigation: any;
  route: any;
}) => {
  const colors = useThemedColors();
  const { id } = route.params;
  const { data: goal, isLoading } = useGoalById(id);

  if (isLoading) {
    return (
      <ThemedBackground>
        <View style={styles.centered}>
          <Text style={[styles.loadingText, { color: colors.text.secondary }]}>Loading...</Text>
        </View>
      </ThemedBackground>
    );
  }

  if (!goal) {
    return (
      <ThemedBackground>
        <View style={styles.centered}>
          <Text style={[styles.errorText, { color: colors.text.primary }]}>Goal not found</Text>
          <Button title="Go Back" onPress={() => navigation.goBack()} />
        </View>
      </ThemedBackground>
    );
  }

  const progress = (goal.current / goal.target) * 100;

  return (
    <ThemedBackground>
      <ScrollView style={styles.container} contentContainerStyle={styles.content}>
        <View style={styles.header}>
          {goal.icon && <Text style={styles.icon}>{goal.icon}</Text>}
          <Text style={[styles.title, { color: colors.text.primary }]}>{goal.title}</Text>
          <Text style={[styles.description, { color: colors.text.secondary }]}>{goal.description}</Text>
        </View>

        <View style={styles.progressSection}>
          <ProgressRing
            progress={progress}
            size={150}
            strokeWidth={15}
            color={goal.color || colors.primary.main}
          />
          <Text style={[styles.progressText, { color: colors.text.primary }]}>
            {goal.current} / {goal.target} {goal.unit}
          </Text>
        </View>

        <View style={styles.statsGrid}>
          <View style={[styles.statCard, { backgroundColor: colors.background.secondary }]}>
            <Text style={[styles.statLabel, { color: colors.text.secondary }]}>Frequency</Text>
            <Text style={[styles.statValue, { color: colors.text.primary }]}>{goal.frequency}</Text>
          </View>
          <View style={[styles.statCard, { backgroundColor: colors.background.secondary }]}>
            <Text style={[styles.statLabel, { color: colors.text.secondary }]}>Streak</Text>
            <Text style={[styles.statValue, { color: colors.text.primary }]}>{goal.streak} days</Text>
          </View>
          <View style={[styles.statCard, { backgroundColor: colors.background.secondary }]}>
            <Text style={[styles.statLabel, { color: colors.text.secondary }]}>Status</Text>
            <Text style={[styles.statValue, { color: colors.text.primary }]}>{goal.status}</Text>
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
    </ThemedBackground>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
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
  },

  errorText: {
    fontSize: typography.fontSize.lg,
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
    textAlign: 'center',
    marginBottom: spacing.sm,
  },

  description: {
    fontSize: typography.fontSize.base,
    textAlign: 'center',
  },

  progressSection: {
    alignItems: 'center',
    marginBottom: spacing.xl,
  },

  progressText: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.semibold,
    marginTop: spacing.lg,
  },

  statsGrid: {
    flexDirection: 'row',
    gap: spacing.md,
    marginBottom: spacing.xl,
  },

  statCard: {
    flex: 1,
    padding: spacing.md,
    borderRadius: 12,
    alignItems: 'center',
  },

  statLabel: {
    fontSize: typography.fontSize.xs,
    marginBottom: spacing.xs,
  },

  statValue: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.semibold,
    textAlign: 'center',
    textTransform: 'capitalize',
  },

  button: {
    marginBottom: spacing.md,
  },
});
