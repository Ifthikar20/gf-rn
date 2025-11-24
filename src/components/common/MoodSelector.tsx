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
    marginVertical: 0,
  },

  moodsContainer: {
    paddingHorizontal: spacing.md,
    gap: spacing.sm,
  },

  moodCard: {
    paddingVertical: spacing.sm,
    paddingHorizontal: spacing.md,
    borderRadius: borderRadius.full,
    alignItems: 'center',
    justifyContent: 'center',
    minWidth: 80,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.04,
    shadowRadius: 6,
    elevation: 1,
  },

  moodIcon: {
    fontSize: 18,
    marginBottom: spacing.xs / 2,
  },

  moodName: {
    fontSize: typography.fontSize.xs,
  },
});
