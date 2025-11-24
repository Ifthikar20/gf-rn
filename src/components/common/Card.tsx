import React from 'react';
import { View, StyleSheet, ViewProps } from 'react-native';
import { spacing, borderRadius } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';

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
  const colors = useThemedColors();

  const variantStyles = {
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
  };

  return (
    <View
      style={[
        styles.card,
        variantStyles[variant],
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
    borderRadius: borderRadius.xl,
  },
});
