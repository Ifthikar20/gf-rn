import React from 'react';
import { View, Text, Image, StyleSheet, TouchableOpacity } from 'react-native';
import { Card } from '@components/common';
import { spacing, typography, borderRadius } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';
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
  const colors = useThemedColors();

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
        <View style={styles.cardContent}>
          {item.thumbnail && (
            <Image source={{ uri: item.thumbnail }} style={styles.thumbnail} />
          )}

          <View style={styles.content}>
            <View style={styles.header}>
              <Text style={[styles.type, { color: colors.primary.main }]}>{item.type.toUpperCase()}</Text>
              <TouchableOpacity onPress={onBookmarkToggle} hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}>
                <Text style={[styles.bookmarkIcon, { color: colors.primary.main }]}>
                  {item.isBookmarked ? '★' : '☆'}
                </Text>
              </TouchableOpacity>
            </View>

            <Text style={[styles.title, { color: colors.text.primary }]} numberOfLines={2}>
              {item.title}
            </Text>

            <Text style={[styles.description, { color: colors.text.secondary }]} numberOfLines={2}>
              {item.description}
            </Text>

            <View style={styles.footer}>
              {getDuration() && (
                <Text style={[styles.duration, { color: colors.text.tertiary }]}>{getDuration()}</Text>
              )}
              {item.author && getDuration() && (
                <Text style={[styles.separator, { color: colors.text.tertiary }]}>•</Text>
              )}
              {item.author && (
                <Text style={[styles.author, { color: colors.text.tertiary }]} numberOfLines={1}>{item.author}</Text>
              )}
            </View>
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

  cardContent: {
    flexDirection: 'row',
  },

  thumbnail: {
    width: 100,
    height: 100,
    borderTopLeftRadius: borderRadius.lg,
    borderBottomLeftRadius: borderRadius.lg,
  },

  content: {
    flex: 1,
    padding: spacing.sm,
  },

  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.xs,
  },

  type: {
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.semibold,
    letterSpacing: 0.5,
  },

  bookmarkIcon: {
    fontSize: 18,
  },

  title: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.semibold,
    marginBottom: spacing.xs / 2,
  },

  description: {
    fontSize: typography.fontSize.xs,
    lineHeight: typography.fontSize.xs * 1.4,
    marginBottom: spacing.xs,
  },

  footer: {
    flexDirection: 'row',
    alignItems: 'center',
  },

  duration: {
    fontSize: typography.fontSize.xs,
  },

  separator: {
    fontSize: typography.fontSize.xs,
    marginHorizontal: spacing.xs / 2,
  },

  author: {
    fontSize: typography.fontSize.xs,
    flex: 1,
  },
});
