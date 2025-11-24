import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView } from 'react-native';
import { useTheme, moods, MoodType } from '@/contexts/ThemeContext';
import { useThemedColors } from '@/hooks/useThemedColors';
import { spacing, typography, borderRadius } from '@theme/index';

export const MoodSelector: React.FC = () => {
  const colors = useThemedColors();
  const { mood, setMood } = useTheme();

  const handleMoodPress = (moodId: MoodType) => {
    setMood(moodId);
  };

  return (
    <View style={styles.container}>
      <ScrollView
        horizontal
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.moodsContainer}
      >
        {moods.map((moodOption) => (
          <TouchableOpacity
            key={moodOption.id}
            style={[
              styles.moodCard,
              {
                backgroundColor: colors.background.primary,
                borderColor: mood === moodOption.id ? colors.primary.main : colors.border.light,
                borderWidth: mood === moodOption.id ? 2 : 1,
              },
            ]}
            onPress={() => handleMoodPress(moodOption.id)}
            activeOpacity={0.7}
          >
            <Text style={styles.moodIcon}>{moodOption.icon}</Text>
            <Text
              style={[
                styles.moodName,
                {
                  color: mood === moodOption.id ? colors.primary.main : colors.text.primary,
                  fontWeight: mood === moodOption.id ? typography.fontWeight.bold : typography.fontWeight.medium,
                },
              ]}
            >
              {moodOption.name}
            </Text>
          </TouchableOpacity>
        ))}
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: spacing.sm,
  },

  moodsContainer: {
    paddingHorizontal: spacing.md,
    gap: spacing.md,
  },

  moodCard: {
    paddingVertical: spacing.md,
    paddingHorizontal: spacing.lg,
    borderRadius: borderRadius.lg,
    alignItems: 'center',
    justifyContent: 'center',
    minWidth: 100,
  },

  moodIcon: {
    fontSize: 28,
    marginBottom: spacing.xs,
  },

  moodName: {
    fontSize: typography.fontSize.sm,
  },
});
