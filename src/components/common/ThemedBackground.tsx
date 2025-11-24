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
        {/* Single uniform opaque overlay */}
        <View
          style={[
            styles.overlay,
            {
              backgroundColor: isDarkMode
                ? 'rgba(15, 23, 42, 0.85)'
                : 'rgba(255, 255, 255, 0.85)',
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
  overlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
  content: {
    flex: 1,
  },
});
