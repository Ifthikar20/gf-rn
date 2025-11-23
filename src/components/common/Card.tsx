import React from 'react';
import { View, StyleSheet, ViewProps } from 'react-native';
import { colors, spacing, borderRadius } from '@theme/index';

interface CardProps extends ViewProps {
  variant?: 'elevated' | 'outlined' | 'filled';
  padding?: number;
}

export const Card: React.FC<CardProps> = ({
  variant = 'elevated',
  padding = spacing.md,
  style,
  children,
  ...props
}) => {
  return (
    <View
      style={[
        styles.card,
        styles[variant],
        { padding },
        style,
      ]}
      {...props}
    >
      {children}
    </View>
  );
};

const styles = StyleSheet.create({
  card: {
    borderRadius: borderRadius.lg,
  },

  elevated: {
    backgroundColor: colors.background.primary,
    shadowColor: colors.neutral[900],
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 3,
  },

  outlined: {
    backgroundColor: colors.background.primary,
    borderWidth: 1,
    borderColor: colors.border.light,
  },

  filled: {
    backgroundColor: colors.background.secondary,
  },
});
