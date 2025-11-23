import { colors, Colors } from './colors';
import { spacing, borderRadius, typography, Spacing, BorderRadius, Typography } from './spacing';

export const theme = {
  colors,
  spacing,
  borderRadius,
  typography,
};

export type Theme = {
  colors: Colors;
  spacing: Spacing;
  borderRadius: BorderRadius;
  typography: Typography;
};

export { colors, spacing, borderRadius, typography };
