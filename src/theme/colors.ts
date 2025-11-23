export const colors = {
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

export type Colors = typeof colors;
