import React from 'react';
import { View, Image, Text, StyleSheet, ViewProps } from 'react-native';
import { colors, typography } from '@theme/index';

type AvatarSize = 'sm' | 'md' | 'lg' | 'xl';

interface AvatarProps extends ViewProps {
  uri?: string;
  name?: string;
  size?: AvatarSize;
}

const sizeMap = {
  sm: 32,
  md: 48,
  lg: 64,
  xl: 96,
};

const fontSizeMap = {
  sm: 12,
  md: 18,
  lg: 24,
  xl: 36,
};

const getInitials = (name: string): string => {
  const parts = name.trim().split(' ');
  if (parts.length >= 2) {
    return `${parts[0][0]}${parts[parts.length - 1][0]}`.toUpperCase();
  }
  return name.substring(0, 2).toUpperCase();
};

const getColorFromName = (name: string): string => {
  const colors_list = [
    '#6366F1', // Indigo
    '#8B5CF6', // Purple
    '#10B981', // Green
    '#3B82F6', // Blue
    '#F59E0B', // Amber
    '#EF4444', // Red
  ];

  let hash = 0;
  for (let i = 0; i < name.length; i++) {
    hash = name.charCodeAt(i) + ((hash << 5) - hash);
  }

  const index = Math.abs(hash) % colors_list.length;
  return colors_list[index];
};

export const Avatar: React.FC<AvatarProps> = ({
  uri,
  name = 'User',
  size = 'md',
  style,
  ...props
}) => {
  const avatarSize = sizeMap[size];
  const fontSize = fontSizeMap[size];
  const backgroundColor = getColorFromName(name);

  return (
    <View
      style={[
        styles.container,
        {
          width: avatarSize,
          height: avatarSize,
          borderRadius: avatarSize / 2,
          backgroundColor: uri ? colors.neutral[200] : backgroundColor,
        },
        style,
      ]}
      {...props}
    >
      {uri ? (
        <Image
          source={{ uri }}
          style={{
            width: avatarSize,
            height: avatarSize,
            borderRadius: avatarSize / 2,
          }}
        />
      ) : (
        <Text
          style={[
            styles.initials,
            {
              fontSize,
            },
          ]}
        >
          {getInitials(name)}
        </Text>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    alignItems: 'center',
    overflow: 'hidden',
  },

  initials: {
    color: colors.text.inverse,
    fontWeight: typography.fontWeight.semibold,
  },
});
