import React from 'react';
import { View, Text, StyleSheet, ScrollView, RefreshControl } from 'react-native';
import { useStore } from '@store/index';
import { useGoals, useGoalStats } from '@hooks/useGoals';
import { useLibrary } from '@hooks/useLibrary';
import { GoalCard } from '@components/goals';
import { ArticleCard } from '@components/library';
import { Avatar } from '@components/common';
import { colors, spacing, typography } from '@theme/index';
import { useToggleBookmark } from '@hooks/useLibrary';

export const HomeScreen: React.FC = () => {
  const user = useStore((state) => state.user);
  const { data: goals, isLoading: goalsLoading, refetch: refetchGoals } = useGoals();
  const { data: stats } = useGoalStats();
  const { data: recentContent, isLoading: contentLoading, refetch: refetchContent } = useLibrary();
  const toggleBookmark = useToggleBookmark();

  const [refreshing, setRefreshing] = React.useState(false);

  const onRefresh = React.useCallback(async () => {
    setRefreshing(true);
    await Promise.all([refetchGoals(), refetchContent()]);
    setRefreshing(false);
  }, [refetchGoals, refetchContent]);

  const activeGoals = goals?.filter((g) => g.status === 'active').slice(0, 3) || [];
  const featuredContent = recentContent?.slice(0, 3) || [];

  return (
    <ScrollView
      style={styles.container}
      contentContainerStyle={styles.content}
      refreshControl={
        <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
      }
    >
      <View style={styles.header}>
        <View>
          <Text style={styles.greeting}>Hello, {user?.name}! 👋</Text>
          <Text style={styles.subGreeting}>Welcome back to your wellness journey</Text>
        </View>
        <Avatar uri={user?.avatar} name={user?.name || ''} size="lg" />
      </View>

      {stats && (
        <View style={styles.statsContainer}>
          <View style={styles.statCard}>
            <Text style={styles.statValue}>{stats.activeGoals}</Text>
            <Text style={styles.statLabel}>Active Goals</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statValue}>{stats.averageStreak}</Text>
            <Text style={styles.statLabel}>Avg Streak</Text>
          </View>
          <View style={styles.statCard}>
            <Text style={styles.statValue}>{stats.totalProgress}%</Text>
            <Text style={styles.statLabel}>Progress</Text>
          </View>
        </View>
      )}

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Active Goals</Text>
        {goalsLoading ? (
          <Text style={styles.loadingText}>Loading...</Text>
        ) : activeGoals.length > 0 ? (
          activeGoals.map((goal) => (
            <GoalCard key={goal.id} goal={goal} onPress={() => {}} />
          ))
        ) : (
          <Text style={styles.emptyText}>No active goals yet</Text>
        )}
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Featured Content</Text>
        {contentLoading ? (
          <Text style={styles.loadingText}>Loading...</Text>
        ) : featuredContent.length > 0 ? (
          featuredContent.map((item) => (
            <ArticleCard
              key={item.id}
              item={item}
              onPress={() => {}}
              onBookmarkToggle={() =>
                toggleBookmark.mutate({
                  contentId: item.id,
                  isBookmarked: !item.isBookmarked,
                })
              }
            />
          ))
        ) : (
          <Text style={styles.emptyText}>No content available</Text>
        )}
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background.secondary,
  },

  content: {
    padding: spacing.screenPadding,
  },

  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.lg,
  },

  greeting: {
    fontSize: typography.fontSize['2xl'],
    fontWeight: typography.fontWeight.bold,
    color: colors.text.primary,
    marginBottom: spacing.xs,
  },

  subGreeting: {
    fontSize: typography.fontSize.sm,
    color: colors.text.secondary,
  },

  statsContainer: {
    flexDirection: 'row',
    gap: spacing.md,
    marginBottom: spacing.lg,
  },

  statCard: {
    flex: 1,
    backgroundColor: colors.background.primary,
    padding: spacing.md,
    borderRadius: 12,
    alignItems: 'center',
  },

  statValue: {
    fontSize: typography.fontSize['2xl'],
    fontWeight: typography.fontWeight.bold,
    color: colors.primary.main,
    marginBottom: spacing.xs,
  },

  statLabel: {
    fontSize: typography.fontSize.xs,
    color: colors.text.secondary,
    textAlign: 'center',
  },

  section: {
    marginBottom: spacing.lg,
  },

  sectionTitle: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.bold,
    color: colors.text.primary,
    marginBottom: spacing.md,
  },

  loadingText: {
    fontSize: typography.fontSize.base,
    color: colors.text.secondary,
    textAlign: 'center',
    padding: spacing.xl,
  },

  emptyText: {
    fontSize: typography.fontSize.base,
    color: colors.text.secondary,
    textAlign: 'center',
    padding: spacing.xl,
  },
});
