import React from 'react';
import { TouchableOpacity, Text, StyleSheet } from 'react-native';
import { spacing, borderRadius, typography } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';
import { ContentCategory } from '@app-types/index';

interface CategoryPillProps {
  category: ContentCategory;
  selected?: boolean;
  onPress: () => void;
}

export const CategoryPill: React.FC<CategoryPillProps> = ({
  category,
  selected = false,
  onPress,
}) => {
  const colors = useThemedColors();

  return (
    <TouchableOpacity
      style={[
        styles.pill,
        { backgroundColor: colors.background.tertiary },
        selected && [styles.pillSelected, { backgroundColor: colors.primary.main }],
      ]}
      onPress={onPress}
      activeOpacity={0.7}
    >
      <Text
        style={[
          styles.text,
          { color: colors.text.secondary },
          selected && [styles.textSelected, { color: colors.primary.contrast }],
        ]}
      >
        {category}
      </Text>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  pill: {
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.sm,
    borderRadius: borderRadius.full,
    marginRight: spacing.sm,
    height: 36,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 1,
    },
    shadowOpacity: 0.03,
    shadowRadius: 4,
    elevation: 1,
  },

  pillSelected: {
    shadowOpacity: 0.15,
    shadowRadius: 8,
    elevation: 3,
  },

  text: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.semibold,
    textTransform: 'capitalize',
  },

  textSelected: {
    fontWeight: typography.fontWeight.bold,
  },
});
