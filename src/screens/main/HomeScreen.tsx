import React from 'react';
import { View, Text, StyleSheet, ScrollView, RefreshControl, SafeAreaView } from 'react-native';
import { useStore } from '@store/index';
import { GoalCard } from '@components/goals';
import { ArticleCard } from '@components/library';
import { Avatar, ThemedBackground } from '@components/common';
import { spacing, typography } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';
import { mockGoals, mockGoalStats, mockLibraryContent } from '@services/mockData';

export const HomeScreen: React.FC = () => {
  const colors = useThemedColors();
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
    <ThemedBackground>
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
            <Text style={[{
              fontSize: typography.fontSize['2xl'],
              fontWeight: typography.fontWeight.bold,
              color: colors.text.primary,
              marginBottom: spacing.xs,
            }]}>Hello, {user?.name}!</Text>
            <Text style={[{
              fontSize: typography.fontSize.sm,
              color: colors.text.secondary,
              lineHeight: typography.fontSize.sm * 1.4,
            }]}>Welcome back to your wellness journey</Text>
          </View>
          <Avatar uri={user?.avatar} name={user?.name || ''} size="md" />
        </View>

        <View style={[{
          flexDirection: 'row',
          gap: spacing.md,
          marginBottom: spacing.lg,
        }]}>
          <View style={[{
            flex: 1,
            backgroundColor: colors.background.primary,
            padding: spacing.md,
            borderRadius: 12,
            alignItems: 'center',
          }]}>
            <Text style={[{
              fontSize: typography.fontSize['2xl'],
              fontWeight: typography.fontWeight.bold,
              color: colors.primary.main,
              marginBottom: spacing.xs,
            }]}>{stats.activeGoals}</Text>
            <Text style={[{
              fontSize: typography.fontSize.xs,
              color: colors.text.secondary,
              textAlign: 'center',
            }]}>Active Goals</Text>
          </View>
          <View style={[{
            flex: 1,
            backgroundColor: colors.background.primary,
            padding: spacing.md,
            borderRadius: 12,
            alignItems: 'center',
          }]}>
            <Text style={[{
              fontSize: typography.fontSize['2xl'],
              fontWeight: typography.fontWeight.bold,
              color: colors.primary.main,
              marginBottom: spacing.xs,
            }]}>{stats.averageStreak}</Text>
            <Text style={[{
              fontSize: typography.fontSize.xs,
              color: colors.text.secondary,
              textAlign: 'center',
            }]}>Avg Streak</Text>
          </View>
          <View style={[{
            flex: 1,
            backgroundColor: colors.background.primary,
            padding: spacing.md,
            borderRadius: 12,
            alignItems: 'center',
          }]}>
            <Text style={[{
              fontSize: typography.fontSize['2xl'],
              fontWeight: typography.fontWeight.bold,
              color: colors.primary.main,
              marginBottom: spacing.xs,
            }]}>{stats.totalProgress}%</Text>
            <Text style={[{
              fontSize: typography.fontSize.xs,
              color: colors.text.secondary,
              textAlign: 'center',
            }]}>Progress</Text>
          </View>
        </View>

        <View style={styles.section}>
          <Text style={[{
            fontSize: typography.fontSize.xl,
            fontWeight: typography.fontWeight.bold,
            color: colors.text.primary,
            marginBottom: spacing.md,
          }]}>Active Goals</Text>
          {activeGoals.map((goal) => (
            <GoalCard key={goal.id} goal={goal} onPress={() => {}} />
          ))}
        </View>

        <View style={styles.section}>
          <Text style={[{
            fontSize: typography.fontSize.xl,
            fontWeight: typography.fontWeight.bold,
            color: colors.text.primary,
            marginBottom: spacing.md,
          }]}>Featured Content</Text>
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

  section: {
    marginBottom: spacing.lg,
  },
});
