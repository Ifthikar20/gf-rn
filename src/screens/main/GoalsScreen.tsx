import React from 'react';
import { View, Text, StyleSheet, FlatList, SafeAreaView, TouchableOpacity } from 'react-native';
import { GoalCard } from '@components/goals';
import { Button, ThemedBackground, MoodSelector } from '@components/common';
import { spacing, typography } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';
import { useTheme } from '@/contexts/ThemeContext';
import { useBackgroundAudio } from '@/hooks/useBackgroundAudio';
import { mockGoals } from '@services/mockData';

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
  const { isMuted, toggleMute } = useTheme();
  useBackgroundAudio(); // Start background audio

  const goals = mockGoals.sort((a, b) =>
    new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime()
  );

  return (
    <ThemedBackground>
      <SafeAreaView style={styles.safeArea}>
        <View style={styles.container}>
          <View style={styles.header}>
            <View>
              <Text style={[styles.title, { color: colors.text.primary }]}>My Goals</Text>
              <Text style={[styles.subtitle, { color: colors.text.secondary }]}>Track your progress</Text>
            </View>
            <View style={styles.headerButtons}>
              <TouchableOpacity onPress={toggleMute} style={styles.muteButton}>
                <Text style={styles.muteIcon}>{isMuted ? '🔇' : '🔊'}</Text>
              </TouchableOpacity>
              <Button title="+" size="sm" onPress={() => {}} style={styles.addButton} />
            </View>
          </View>

          {/* Mood Selector */}
          <View style={styles.moodSelectorContainer}>
            <View style={styles.moodLabelContainer}>
              <Text style={[styles.moodLabel, { color: colors.text.primary }]}>How are you feeling</Text>
              <Text style={[styles.moodLabelAccent, { color: colors.primary.main }]}>today?</Text>
            </View>
            <MoodSelector />
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

  headerButtons: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: spacing.sm,
  },

  muteButton: {
    width: 44,
    height: 44,
    alignItems: 'center',
    justifyContent: 'center',
  },

  muteIcon: {
    fontSize: 24,
  },

  addButton: {
    width: 44,
    minHeight: 44,
  },

  moodSelectorContainer: {
    marginHorizontal: spacing.screenPadding,
    marginBottom: spacing.xl,
    paddingTop: spacing.sm,
  },

  moodLabelContainer: {
    flexDirection: 'row',
    alignItems: 'baseline',
    marginBottom: spacing.md,
    marginLeft: spacing.xs,
    gap: spacing.xs,
  },

  moodLabel: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.semibold,
    letterSpacing: -0.3,
  },

  moodLabelAccent: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.bold,
    letterSpacing: -0.3,
  },

  listContent: {
    padding: spacing.screenPadding,
  },

  timelineItem: {
    flexDirection: 'row',
    marginBottom: spacing.xl,
  },

  timelineLeft: {
    width: 50,
    alignItems: 'center',
    paddingTop: spacing.sm,
  },

  dateText: {
    fontSize: 9,
    marginBottom: spacing.xs,
    textAlign: 'center',
    lineHeight: 12,
    fontWeight: typography.fontWeight.medium,
  },

  timelineDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    borderWidth: 2.5,
    zIndex: 1,
  },

  timelineLine: {
    position: 'absolute',
    width: 1.5,
    top: 36,
    bottom: -spacing.xl,
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
