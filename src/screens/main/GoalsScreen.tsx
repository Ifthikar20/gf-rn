import React from 'react';
import { View, Text, StyleSheet, FlatList, SafeAreaView } from 'react-native';
import { GoalCard } from '@components/goals';
import { Button } from '@components/common';
import { colors, spacing, typography } from '@theme/index';
import { mockGoals, mockGoalStats } from '@services/mockData';

export const GoalsScreen: React.FC = () => {
  const goals = mockGoals;
  const stats = mockGoalStats;

  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        <View style={styles.header}>
          <View>
            <Text style={styles.title}>My Goals</Text>
            <Text style={styles.subtitle}>Track your progress</Text>
          </View>
          <Button title="+" size="sm" onPress={() => {}} style={styles.addButton} />
        </View>

        <View style={styles.statsRow}>
          <View style={styles.stat}>
            <Text style={styles.statValue}>{stats.totalGoals}</Text>
            <Text style={styles.statLabel}>Total</Text>
          </View>
          <View style={styles.stat}>
            <Text style={styles.statValue}>{stats.activeGoals}</Text>
            <Text style={styles.statLabel}>Active</Text>
          </View>
          <View style={styles.stat}>
            <Text style={styles.statValue}>{stats.completedGoals}</Text>
            <Text style={styles.statLabel}>Completed</Text>
          </View>
          <View style={styles.stat}>
            <Text style={styles.statValue}>{stats.longestStreak}</Text>
            <Text style={styles.statLabel}>Best Streak</Text>
          </View>
        </View>

        <FlatList
          data={goals}
          keyExtractor={(item) => item.id}
          renderItem={({ item }) => <GoalCard goal={item} onPress={() => {}} />}
          contentContainerStyle={styles.listContent}
          showsVerticalScrollIndicator={false}
        />
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: colors.background.secondary,
  },

  container: {
    flex: 1,
    backgroundColor: colors.background.secondary,
  },

  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: spacing.screenPadding,
    paddingBottom: spacing.md,
  },

  title: {
    fontSize: typography.fontSize['3xl'],
    fontWeight: typography.fontWeight.bold,
    color: colors.text.primary,
    marginBottom: spacing.xs,
  },

  subtitle: {
    fontSize: typography.fontSize.base,
    color: colors.text.secondary,
  },

  addButton: {
    width: 44,
    minHeight: 44,
  },

  statsRow: {
    flexDirection: 'row',
    backgroundColor: colors.background.primary,
    marginHorizontal: spacing.screenPadding,
    marginBottom: spacing.md,
    padding: spacing.md,
    borderRadius: 12,
  },

  stat: {
    flex: 1,
    alignItems: 'center',
  },

  statValue: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.bold,
    color: colors.primary.main,
    marginBottom: spacing.xs / 2,
  },

  statLabel: {
    fontSize: typography.fontSize.xs,
    color: colors.text.secondary,
  },

  listContent: {
    padding: spacing.screenPadding,
  },

  emptyContainer: {
    alignItems: 'center',
    paddingVertical: spacing.xxxl,
  },

  emptyIcon: {
    fontSize: 64,
    marginBottom: spacing.md,
  },

  emptyText: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
    color: colors.text.primary,
    marginBottom: spacing.xs,
  },

  emptySubtext: {
    fontSize: typography.fontSize.sm,
    color: colors.text.secondary,
  },
});
