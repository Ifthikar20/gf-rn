import React, { ReactNode } from 'react';
import { StyleSheet, View, ImageBackground } from 'react-native';
import { useTheme } from '@/contexts/ThemeContext';

interface ThemedBackgroundProps {
  children: ReactNode;
}

export const ThemedBackground: React.FC<ThemedBackgroundProps> = ({ children }) => {
  const { isDarkMode, getMoodConfig } = useTheme();
  const moodConfig = getMoodConfig();

  // Get the appropriate background image based on theme
  const backgroundImage = isDarkMode ? moodConfig.darkBackground : moodConfig.lightBackground;

  return (
    <View style={styles.container}>
      <ImageBackground
        source={{ uri: backgroundImage }}
        style={styles.backgroundImage}
        resizeMode="cover"
      >
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
      </ImageBackground>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  backgroundImage: {
    flex: 1,
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
