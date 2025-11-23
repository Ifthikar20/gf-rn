import React from 'react';
import { View, Text, StyleSheet, FlatList, SafeAreaView } from 'react-native';
import { GoalCard } from '@components/goals';
import { Button } from '@components/common';
import { colors, spacing, typography } from '@theme/index';
import { mockGoals, mockGoalStats } from '@services/mockData';

const formatDate = (dateString: string) => {
  const date = new Date(dateString);
  const now = new Date();
  const diffTime = Math.abs(now.getTime() - date.getTime());
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

  if (diffDays === 0) return 'Today';
  if (diffDays === 1) return 'Yesterday';
  if (diffDays < 7) return `${diffDays} days ago`;
  if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`;

  return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
};

export const GoalsScreen: React.FC = () => {
  const goals = mockGoals.sort((a, b) =>
    new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime()
  );
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
          renderItem={({ item, index }) => (
            <View style={styles.timelineItem}>
              <View style={styles.timelineLeft}>
                <Text style={styles.dateText}>{formatDate(item.updatedAt)}</Text>
                <View style={styles.timelineDot} />
                {index < goals.length - 1 && <View style={styles.timelineLine} />}
              </View>
              <View style={styles.timelineRight}>
                <GoalCard goal={item} onPress={() => {}} />
              </View>
            </View>
          )}
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

  timelineItem: {
    flexDirection: 'row',
    marginBottom: spacing.md,
  },

  timelineLeft: {
    width: 60,
    alignItems: 'center',
    paddingTop: spacing.xs,
  },

  dateText: {
    fontSize: 10,
    color: colors.text.secondary,
    marginBottom: spacing.xs,
    textAlign: 'center',
    lineHeight: 12,
    fontWeight: typography.fontWeight.medium,
  },

  timelineDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    backgroundColor: colors.primary.main,
    borderWidth: 2,
    borderColor: colors.background.secondary,
    zIndex: 1,
  },

  timelineLine: {
    position: 'absolute',
    width: 2,
    backgroundColor: colors.border.light,
    top: 38,
    bottom: -20,
  },

  timelineRight: {
    flex: 1,
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
