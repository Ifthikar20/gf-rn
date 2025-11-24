import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { useColorScheme } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';

type ThemeMode = 'light' | 'dark' | 'auto';
export type MoodType = 'happy' | 'sad' | 'nervous' | 'calm' | 'energetic';

export interface MoodConfig {
  id: MoodType;
  name: string;
  icon: string;
  lightBackground: string;
  darkBackground: string;
}

export const moods: MoodConfig[] = [
  {
    id: 'happy',
    name: 'Happy',
    icon: '😊',
    lightBackground: 'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=1200', // Morning sunshine
    darkBackground: 'https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=1200',
  },
  {
    id: 'calm',
    name: 'Calm',
    icon: '😌',
    lightBackground: 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=1200', // Waterfall
    darkBackground: 'https://images.unsplash.com/photo-1439066615861-d1af74d74000?w=1200',
  },
  {
    id: 'nervous',
    name: 'Nervous',
    icon: '😰',
    lightBackground: 'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=1200', // Night sky
    darkBackground: 'https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=1200',
  },
  {
    id: 'sad',
    name: 'Sad',
    icon: '😔',
    lightBackground: 'https://images.unsplash.com/photo-1428908728789-d2de25dbd4e2?w=1200', // Rain
    darkBackground: 'https://images.unsplash.com/photo-1428908728789-d2de25dbd4e2?w=1200',
  },
  {
    id: 'energetic',
    name: 'Energetic',
    icon: '⚡',
    lightBackground: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200', // Mountain sunrise
    darkBackground: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200',
  },
];

interface ThemeContextType {
  isDarkMode: boolean;
  themeMode: ThemeMode;
  setThemeMode: (mode: ThemeMode) => void;
  toggleTheme: () => void;
  mood: MoodType;
  setMood: (mood: MoodType) => void;
  getMoodConfig: () => MoodConfig;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

const THEME_STORAGE_KEY = '@theme_mode';
const MOOD_STORAGE_KEY = '@mood_preference';

export const ThemeProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const systemColorScheme = useColorScheme();
  const [themeMode, setThemeModeState] = useState<ThemeMode>('auto');
  const [isDarkMode, setIsDarkMode] = useState(systemColorScheme === 'dark');
  const [mood, setMoodState] = useState<MoodType>('calm');

  useEffect(() => {
    loadThemePreference();
    loadMoodPreference();
  }, []);

  useEffect(() => {
    if (themeMode === 'auto') {
      setIsDarkMode(systemColorScheme === 'dark');
    } else {
      setIsDarkMode(themeMode === 'dark');
    }
  }, [themeMode, systemColorScheme]);

  const loadThemePreference = async () => {
    try {
      const savedMode = await AsyncStorage.getItem(THEME_STORAGE_KEY);
      if (savedMode && (savedMode === 'light' || savedMode === 'dark' || savedMode === 'auto')) {
        setThemeModeState(savedMode as ThemeMode);
      }
    } catch (error) {
      console.error('Failed to load theme preference:', error);
    }
  };

  const loadMoodPreference = async () => {
    try {
      const savedMood = await AsyncStorage.getItem(MOOD_STORAGE_KEY);
      if (savedMood && moods.find(m => m.id === savedMood)) {
        setMoodState(savedMood as MoodType);
      }
    } catch (error) {
      console.error('Failed to load mood preference:', error);
    }
  };

  const setThemeMode = async (mode: ThemeMode) => {
    try {
      await AsyncStorage.setItem(THEME_STORAGE_KEY, mode);
      setThemeModeState(mode);
    } catch (error) {
      console.error('Failed to save theme preference:', error);
    }
  };

  const setMood = async (newMood: MoodType) => {
    try {
      await AsyncStorage.setItem(MOOD_STORAGE_KEY, newMood);
      setMoodState(newMood);
    } catch (error) {
      console.error('Failed to save mood preference:', error);
    }
  };

  const toggleTheme = () => {
    const newMode = isDarkMode ? 'light' : 'dark';
    setThemeMode(newMode);
  };

  const getMoodConfig = (): MoodConfig => {
    return moods.find(m => m.id === mood) || moods[1]; // Default to calm
  };

  return (
    <ThemeContext.Provider value={{ isDarkMode, themeMode, setThemeMode, toggleTheme, mood, setMood, getMoodConfig }}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useTheme = (): ThemeContextType => {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within a ThemeProvider');
  }
  return context;
};
