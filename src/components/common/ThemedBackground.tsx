import React, { ReactNode } from 'react';
import { StyleSheet, View } from 'react-native';
import { useTheme } from '@/contexts/ThemeContext';

interface ThemedBackgroundProps {
  children: ReactNode;
}

export const ThemedBackground: React.FC<ThemedBackgroundProps> = ({ children }) => {
  const { isDarkMode } = useTheme();

  // Base background color with subtle pattern effect
  const baseBackgroundColor = isDarkMode ? '#0F172A' : '#F0F4FF';

  return (
    <View style={[styles.container, { backgroundColor: baseBackgroundColor }]}>
      {/* Background pattern layers */}
      <View
        style={[
          styles.patternLayer,
          {
            backgroundColor: isDarkMode
              ? 'rgba(99, 102, 241, 0.05)'
              : 'rgba(99, 102, 241, 0.08)',
          },
        ]}
      />

      {/* Top gradient overlay - more transparent */}
      <View
        style={[
          styles.topOverlay,
          {
            backgroundColor: isDarkMode
              ? 'rgba(15, 23, 42, 0.3)'
              : 'rgba(255, 255, 255, 0.3)',
          },
        ]}
      />

      {/* Center overlay - more opaque */}
      <View
        style={[
          styles.centerOverlay,
          {
            backgroundColor: isDarkMode
              ? 'rgba(15, 23, 42, 0.6)'
              : 'rgba(255, 255, 255, 0.6)',
          },
        ]}
      />

      {/* Bottom gradient overlay - more transparent */}
      <View
        style={[
          styles.bottomOverlay,
          {
            backgroundColor: isDarkMode
              ? 'rgba(15, 23, 42, 0.3)'
              : 'rgba(255, 255, 255, 0.3)',
          },
        ]}
      />

      {/* Content */}
      <View style={styles.content}>
        {children}
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  patternLayer: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
  topOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    height: '25%',
  },
  centerOverlay: {
    position: 'absolute',
    top: '25%',
    left: 0,
    right: 0,
    height: '50%',
  },
  bottomOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    height: '25%',
  },
  content: {
    flex: 1,
  },
});
