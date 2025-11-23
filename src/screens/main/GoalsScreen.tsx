import React from 'react';
import { View, Text, StyleSheet, FlatList, SafeAreaView } from 'react-native';
import { GoalCard } from '@components/goals';
import { Button, ThemedBackground } from '@components/common';
import { spacing, typography } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';
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
  const colors = useThemedColors();
  const goals = mockGoals.sort((a, b) =>
    new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime()
  );
  const stats = mockGoalStats;

  return (
    <ThemedBackground>
      <SafeAreaView style={styles.safeArea}>
        <View style={styles.container}>
          <View style={styles.header}>
            <View>
              <Text style={[styles.title, { color: colors.text.primary }]}>My Goals</Text>
              <Text style={[styles.subtitle, { color: colors.text.secondary }]}>Track your progress</Text>
            </View>
            <Button title="+" size="sm" onPress={() => {}} style={styles.addButton} />
          </View>

          <View style={[styles.statsRow, { backgroundColor: colors.background.primary }]}>
            <View style={styles.stat}>
              <Text style={[styles.statValue, { color: colors.primary.main }]}>{stats.totalGoals}</Text>
              <Text style={[styles.statLabel, { color: colors.text.secondary }]}>Total</Text>
            </View>
            <View style={styles.stat}>
              <Text style={[styles.statValue, { color: colors.primary.main }]}>{stats.activeGoals}</Text>
              <Text style={[styles.statLabel, { color: colors.text.secondary }]}>Active</Text>
            </View>
            <View style={styles.stat}>
              <Text style={[styles.statValue, { color: colors.primary.main }]}>{stats.completedGoals}</Text>
              <Text style={[styles.statLabel, { color: colors.text.secondary }]}>Completed</Text>
            </View>
            <View style={styles.stat}>
              <Text style={[styles.statValue, { color: colors.primary.main }]}>{stats.longestStreak}</Text>
              <Text style={[styles.statLabel, { color: colors.text.secondary }]}>Best Streak</Text>
            </View>
          </View>

          <FlatList
            data={goals}
            keyExtractor={(item) => item.id}
            renderItem={({ item, index }) => (
              <View style={styles.timelineItem}>
                <View style={styles.timelineLeft}>
                  <Text style={[styles.dateText, { color: colors.text.secondary }]}>{formatDate(item.updatedAt)}</Text>
                  <View style={[styles.timelineDot, { backgroundColor: colors.primary.main, borderColor: colors.background.secondary }]} />
                  {index < goals.length - 1 && <View style={[styles.timelineLine, { backgroundColor: colors.border.light }]} />}
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
    </ThemedBackground>
  );
};

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
  },

  container: {
    flex: 1,
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
    marginBottom: spacing.xs,
  },

  subtitle: {
    fontSize: typography.fontSize.base,
  },

  addButton: {
    width: 44,
    minHeight: 44,
  },

  statsRow: {
    flexDirection: 'row',
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
    marginBottom: spacing.xs / 2,
  },

  statLabel: {
    fontSize: typography.fontSize.xs,
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
    marginBottom: spacing.xs,
    textAlign: 'center',
    lineHeight: 12,
    fontWeight: typography.fontWeight.medium,
  },

  timelineDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    borderWidth: 2,
    zIndex: 1,
  },

  timelineLine: {
    position: 'absolute',
    width: 2,
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
    marginBottom: spacing.xs,
  },

  emptySubtext: {
    fontSize: typography.fontSize.sm,
  },
});
