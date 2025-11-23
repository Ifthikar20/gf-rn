import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { colors, typography } from '@theme/index';

interface ProgressRingProps {
  progress: number; // 0-100
  size?: number;
  strokeWidth?: number;
  color?: string;
  showPercentage?: boolean;
}

export const ProgressRing: React.FC<ProgressRingProps> = ({
  progress,
  size = 80,
  strokeWidth = 8,
  color = colors.primary.main,
  showPercentage = true,
}) => {
  const progressValue = Math.min(Math.max(progress, 0), 100);

  // Simple circular progress using border
  return (
    <View
      style={[
        styles.container,
        {
          width: size,
          height: size,
          borderRadius: size / 2,
          borderWidth: strokeWidth,
          borderColor: colors.neutral[200],
        },
      ]}
    >
      {/* Progress overlay - simplified representation */}
      <View
        style={[
          styles.progressOverlay,
          {
            width: size - strokeWidth * 2,
            height: size - strokeWidth * 2,
            borderRadius: (size - strokeWidth * 2) / 2,
            backgroundColor: progressValue > 75 ? `${color}20` : 'transparent',
          },
        ]}
      >
        {showPercentage && (
          <Text style={[styles.percentage, { color }]}>
            {Math.round(progressValue)}%
          </Text>
        )}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: colors.background.primary,
  },

  progressOverlay: {
    justifyContent: 'center',
    alignItems: 'center',
  },

  percentage: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.bold,
  },
});
