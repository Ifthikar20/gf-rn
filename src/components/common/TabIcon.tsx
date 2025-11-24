import React from 'react';
import { View, Text, StyleSheet } from 'react-native';

interface TabIconProps {
  name: 'goals' | 'library' | 'meditate' | 'discover' | 'profile';
  color: string;
  size?: number;
}

export const TabIcon: React.FC<TabIconProps> = ({ name, color, size = 24 }) => {
  // Using styled text icons as a temporary solution until react-native-svg is properly linked
  const icons = {
    goals: '◎',      // Target/bullseye
    library: '▢',    // Book/library
    meditate: '✦',   // Star/meditation
    discover: '◉',   // Search/discover
    profile: '◗',    // Person/profile
  };

  return (
    <View style={[styles.container, { width: size, height: size }]}>
      <Text style={[styles.icon, { color, fontSize: size }]}>
        {icons[name]}
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  icon: {
    fontWeight: '300',
  },
});
