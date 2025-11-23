import React from 'react';
import { View, Text, Image, StyleSheet, TouchableOpacity } from 'react-native';
import { Card } from '@components/common';
import { colors, spacing, typography, borderRadius } from '@theme/index';
import { ContentItem } from '@app-types/index';

interface ArticleCardProps {
  item: ContentItem;
  onPress: () => void;
  onBookmarkToggle: () => void;
}

export const ArticleCard: React.FC<ArticleCardProps> = ({
  item,
  onPress,
  onBookmarkToggle,
}) => {
  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'article':
        return '📄';
      case 'video':
        return '🎥';
      case 'audio':
        return '🎧';
      case 'meditation':
        return '🧘';
      default:
        return '📄';
    }
  };

  const getDuration = () => {
    if (item.duration) {
      const minutes = Math.floor(item.duration / 60);
      return `${minutes} min`;
    }
    if (item.readTime) {
      return `${item.readTime} min read`;
    }
    return null;
  };

  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.7}>
      <Card padding={0} style={styles.card}>
        {item.thumbnail && (
          <Image source={{ uri: item.thumbnail }} style={styles.thumbnail} />
        )}

        <View style={styles.content}>
          <View style={styles.header}>
            <View style={styles.typeContainer}>
              <Text style={styles.typeIcon}>{getTypeIcon(item.type)}</Text>
              <Text style={styles.type}>{item.type}</Text>
            </View>

            <TouchableOpacity onPress={onBookmarkToggle} hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}>
              <Text style={styles.bookmarkIcon}>
                {item.isBookmarked ? '🔖' : '📑'}
              </Text>
            </TouchableOpacity>
          </View>

          <Text style={styles.title} numberOfLines={2}>
            {item.title}
          </Text>

          <Text style={styles.description} numberOfLines={2}>
            {item.description}
          </Text>

          <View style={styles.footer}>
            {getDuration() && (
              <Text style={styles.duration}>{getDuration()}</Text>
            )}
            {item.author && (
              <>
                <Text style={styles.separator}>•</Text>
                <Text style={styles.author}>{item.author}</Text>
              </>
            )}
          </View>
        </View>
      </Card>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  card: {
    marginBottom: spacing.md,
  },

  thumbnail: {
    width: '100%',
    height: 180,
    borderTopLeftRadius: borderRadius.lg,
    borderTopRightRadius: borderRadius.lg,
  },

  content: {
    padding: spacing.md,
  },

  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.sm,
  },

  typeContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },

  typeIcon: {
    fontSize: typography.fontSize.base,
    marginRight: spacing.xs,
  },

  type: {
    fontSize: typography.fontSize.sm,
    color: colors.text.secondary,
    textTransform: 'capitalize',
  },

  bookmarkIcon: {
    fontSize: typography.fontSize.xl,
  },

  title: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
    color: colors.text.primary,
    marginBottom: spacing.xs,
  },

  description: {
    fontSize: typography.fontSize.sm,
    color: colors.text.secondary,
    lineHeight: typography.fontSize.sm * typography.lineHeight.normal,
    marginBottom: spacing.sm,
  },

  footer: {
    flexDirection: 'row',
    alignItems: 'center',
  },

  duration: {
    fontSize: typography.fontSize.xs,
    color: colors.text.tertiary,
  },

  separator: {
    fontSize: typography.fontSize.xs,
    color: colors.text.tertiary,
    marginHorizontal: spacing.xs,
  },

  author: {
    fontSize: typography.fontSize.xs,
    color: colors.text.tertiary,
  },
});
