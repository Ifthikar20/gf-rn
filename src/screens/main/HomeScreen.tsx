import React from 'react';
import { View, Text, StyleSheet, ScrollView, RefreshControl, SafeAreaView } from 'react-native';
import { useStore } from '@store/index';
import { GoalCard } from '@components/goals';
import { ArticleCard } from '@components/library';
import { Avatar } from '@components/common';
import { colors, spacing, typography } from '@theme/index';
import { mockGoals, mockGoalStats, mockLibraryContent } from '@services/mockData';

export const HomeScreen: React.FC = () => {
  const user = useStore((state) => state.user);
  const [refreshing, setRefreshing] = React.useState(false);

  const onRefresh = React.useCallback(async () => {
    setRefreshing(true);
    // Simulate refresh delay
    setTimeout(() => setRefreshing(false), 1000);
  }, []);

  // Use mock data
  const activeGoals = mockGoals.filter((g) => g.status === 'active').slice(0, 3);
  const featuredContent = mockLibraryContent.slice(0, 3);
  const stats = mockGoalStats;

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView
        style={styles.container}
        contentContainerStyle={styles.content}
        refreshControl={
          <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
        }
        showsVerticalScrollIndicator={false}
      >
        <View style={styles.header}>
          <View style={styles.headerText}>
            <Text style={styles.greeting}>Hello, {user?.name}!</Text>
            <Text style={styles.subGreeting}>Welcome back to your wellness journey</Text>
          </View>
          <Avatar uri={user?.avatar} name={user?.name || ''} size="md" />
        </View>

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

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Active Goals</Text>
          {activeGoals.map((goal) => (
            <GoalCard key={goal.id} goal={goal} onPress={() => {}} />
          ))}
        </View>

        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Featured Content</Text>
          {featuredContent.map((item) => (
            <ArticleCard
              key={item.id}
              item={item}
              onPress={() => {}}
              onBookmarkToggle={() => {}}
            />
          ))}
        </View>
      </ScrollView>
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

  content: {
    padding: spacing.screenPadding,
    paddingTop: spacing.md,
  },

  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.xl,
    marginTop: spacing.sm,
  },

  headerText: {
    flex: 1,
    marginRight: spacing.md,
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
    lineHeight: typography.fontSize.sm * 1.4,
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
