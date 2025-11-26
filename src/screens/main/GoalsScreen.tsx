import React from 'react';
import { View, Text, StyleSheet, ScrollView, SafeAreaView, TouchableOpacity } from 'react-native';
import { GoalCard } from '@components/goals';
import { ThemedBackground } from '@components/common';
import { spacing, typography, borderRadius } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';
import { useTheme } from '@/contexts/ThemeContext';
import { useBackgroundAudio } from '@/hooks/useBackgroundAudio';
import { mockGoals } from '@services/mockData';
import { Goal, TimeOfDay } from '@app-types/index';

const getSectionIcon = (timeOfDay: TimeOfDay) => {
  switch (timeOfDay) {
    case 'morning':
      return '☀️';
    case 'day':
      return '☼';
    case 'evening':
      return '☾';
    default:
      return '●';
  }
};

const getSectionTitle = (timeOfDay: TimeOfDay) => {
  switch (timeOfDay) {
    case 'morning':
      return 'Morning';
    case 'day':
      return 'Day';
    case 'evening':
      return 'Evening';
    default:
      return '';
  }
};

export const GoalsScreen: React.FC = () => {
  const colors = useThemedColors();
  const { isMuted, toggleMute } = useTheme();
  useBackgroundAudio(); // Start background audio

  // Group goals by time of day
  const morningGoals = mockGoals.filter((g) => g.timeOfDay === 'morning');
  const dayGoals = mockGoals.filter((g) => g.timeOfDay === 'day');
  const eveningGoals = mockGoals.filter((g) => g.timeOfDay === 'evening');

  const renderSection = (timeOfDay: TimeOfDay, goals: Goal[]) => {
    if (goals.length === 0) return null;

    return (
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionIcon}>{getSectionIcon(timeOfDay)}</Text>
          <Text style={[styles.sectionTitle, { color: colors.text.secondary }]}>
            {getSectionTitle(timeOfDay)}
          </Text>
        </View>
        {goals.map((goal) => (
          <GoalCard key={goal.id} goal={goal} onPress={() => {}} />
        ))}
      </View>
    );
  };

  return (
    <ThemedBackground>
      <SafeAreaView style={styles.safeArea}>
        <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
          {/* Header */}
          <View style={styles.header}>
            <View>
              <Text style={[styles.title, { color: colors.text.primary }]}>Plan</Text>
              <Text style={[styles.date, { color: colors.text.secondary }]}>
                {new Date().toLocaleDateString('en-US', {
                  weekday: 'long',
                  month: 'long',
                  day: 'numeric'
                })}
              </Text>
            </View>
            <TouchableOpacity style={styles.profileButton}>
              <View style={[styles.profileIcon, { backgroundColor: colors.primary.main }]}>
                <Text style={styles.profileText}>👤</Text>
              </View>
            </TouchableOpacity>
          </View>

          {/* Morning Section */}
          {renderSection('morning', morningGoals)}

          {/* Day Section */}
          {renderSection('day', dayGoals)}

          {/* Evening Section */}
          {renderSection('evening', eveningGoals)}

          {/* Welcome Message */}
          <TouchableOpacity
            style={[styles.welcomeMessage, { backgroundColor: colors.primary.main }]}
            activeOpacity={0.8}
          >
            <Text style={styles.welcomeIcon}>✉️</Text>
            <View style={styles.welcomeContent}>
              <Text style={[styles.welcomeTitle, { color: colors.text.inverse }]}>
                Welcome aboard!
              </Text>
              <Text style={[styles.welcomeSubtitle, { color: colors.text.inverse }]}>
                You have 1 new message
              </Text>
            </View>
            <Text style={[styles.welcomeArrow, { color: colors.text.inverse }]}>›</Text>
          </TouchableOpacity>

          <View style={styles.bottomPadding} />
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

  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    padding: spacing.screenPadding,
    paddingTop: spacing.lg,
    paddingBottom: spacing.md,
  },

  title: {
    fontSize: typography.fontSize['3xl'],
    fontWeight: typography.fontWeight.bold,
    marginBottom: spacing.xs / 2,
  },

  date: {
    fontSize: typography.fontSize.sm,
  },

  profileButton: {
    padding: spacing.xs,
  },

  profileIcon: {
    width: 44,
    height: 44,
    borderRadius: 22,
    alignItems: 'center',
    justifyContent: 'center',
  },

  profileText: {
    fontSize: 20,
  },

  section: {
    marginBottom: spacing.xl,
  },

  sectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: spacing.md,
    paddingHorizontal: spacing.screenPadding,
  },

  sectionIcon: {
    fontSize: 24,
    marginRight: spacing.sm,
  },

  sectionTitle: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
  },

  welcomeMessage: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: spacing.md,
    marginHorizontal: spacing.screenPadding,
    marginVertical: spacing.lg,
    borderRadius: borderRadius.xl,
  },

  welcomeIcon: {
    fontSize: 28,
    marginRight: spacing.md,
  },

  welcomeContent: {
    flex: 1,
  },

  welcomeTitle: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.semibold,
    marginBottom: spacing.xs / 2,
  },

  welcomeSubtitle: {
    fontSize: typography.fontSize.sm,
    opacity: 0.9,
  },

  welcomeArrow: {
    fontSize: 32,
    fontWeight: typography.fontWeight.light,
  },

  bottomPadding: {
    height: spacing.xl,
  },
});
