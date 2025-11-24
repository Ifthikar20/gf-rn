export const lightColors = {
  // Primary colors
  primary: {
    main: '#6366F1',      // Indigo
    light: '#818CF8',
    dark: '#4F46E5',
    contrast: '#FFFFFF',
  },

  // Secondary colors
  secondary: {
    main: '#8B5CF6',      // Purple
    light: '#A78BFA',
    dark: '#7C3AED',
    contrast: '#FFFFFF',
  },

  // Semantic colors
  success: {
    main: '#10B981',      // Green
    light: '#34D399',
    dark: '#059669',
    background: '#D1FAE5',
  },

  error: {
    main: '#EF4444',      // Red
    light: '#F87171',
    dark: '#DC2626',
    background: '#FEE2E2',
  },

  warning: {
    main: '#F59E0B',      // Amber
    light: '#FBBF24',
    dark: '#D97706',
    background: '#FEF3C7',
  },

  info: {
    main: '#3B82F6',      // Blue
    light: '#60A5FA',
    dark: '#2563EB',
    background: '#DBEAFE',
  },

  // Neutral colors
  neutral: {
    50: '#F9FAFB',
    100: '#F3F4F6',
    200: '#E5E7EB',
    300: '#D1D5DB',
    400: '#9CA3AF',
    500: '#6B7280',
    600: '#4B5563',
    700: '#374151',
    800: '#1F2937',
    900: '#111827',
  },

  // Background colors
  background: {
    primary: '#FFFFFF',
    secondary: '#F9FAFB',
    tertiary: '#F3F4F6',
    dark: '#111827',
  },

  // Text colors
  text: {
    primary: '#111827',
    secondary: '#6B7280',
    tertiary: '#9CA3AF',
    disabled: '#D1D5DB',
    inverse: '#FFFFFF',
  },

  // Border colors
  border: {
    light: '#E5E7EB',
    main: '#D1D5DB',
    dark: '#9CA3AF',
  },

  // Overlay colors
  overlay: {
    light: 'rgba(0, 0, 0, 0.1)',
    medium: 'rgba(0, 0, 0, 0.3)',
    dark: 'rgba(0, 0, 0, 0.6)',
  },
};

export const darkColors = {
  // Primary colors
  primary: {
    main: '#818CF8',      // Lighter Indigo for dark mode
    light: '#A5B4FC',
    dark: '#6366F1',
    contrast: '#FFFFFF',
  },

  // Secondary colors
  secondary: {
    main: '#A78BFA',      // Lighter Purple for dark mode
    light: '#C4B5FD',
    dark: '#8B5CF6',
    contrast: '#FFFFFF',
  },

  // Semantic colors
  success: {
    main: '#34D399',      // Lighter Green for dark mode
    light: '#6EE7B7',
    dark: '#10B981',
    background: '#064E3B',
  },

  error: {
    main: '#F87171',      // Lighter Red for dark mode
    light: '#FCA5A5',
    dark: '#EF4444',
    background: '#7F1D1D',
  },

  warning: {
    main: '#FBBF24',      // Lighter Amber for dark mode
    light: '#FCD34D',
    dark: '#F59E0B',
    background: '#78350F',
  },

  info: {
    main: '#60A5FA',      // Lighter Blue for dark mode
    light: '#93C5FD',
    dark: '#3B82F6',
    background: '#1E3A8A',
  },

  // Neutral colors (reversed for dark mode)
  neutral: {
    50: '#111827',
    100: '#1F2937',
    200: '#374151',
    300: '#4B5563',
    400: '#6B7280',
    500: '#9CA3AF',
    600: '#D1D5DB',
    700: '#E5E7EB',
    800: '#F3F4F6',
    900: '#F9FAFB',
  },

  // Background colors
  background: {
    primary: '#000000',    // Pure black
    secondary: '#0A0A0A',  // Slightly lighter black
    tertiary: '#1A1A1A',   // Dark gray
    dark: '#000000',       // Pure black
  },

  // Text colors
  text: {
    primary: '#FFFFFF',    // Pure white
    secondary: '#E5E5E5',  // Light gray
    tertiary: '#B3B3B3',   // Medium gray
    disabled: '#6B7280',
    inverse: '#000000',    // Black
  },

  // Border colors
  border: {
    light: '#1A1A1A',
    main: '#2A2A2A',
    dark: '#3A3A3A',
  },

  // Overlay colors
  overlay: {
    light: 'rgba(0, 0, 0, 0.3)',
    medium: 'rgba(0, 0, 0, 0.5)',
    dark: 'rgba(0, 0, 0, 0.8)',
  },
};

export const colors = lightColors;
export type Colors = typeof lightColors;
