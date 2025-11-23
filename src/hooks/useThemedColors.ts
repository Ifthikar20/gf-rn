import { useTheme } from '@/contexts/ThemeContext';
import { lightColors, darkColors, Colors } from '@theme/colors';

export const useThemedColors = (): Colors => {
  const { isDarkMode } = useTheme();
  return isDarkMode ? darkColors : lightColors;
};
