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
    overflow: 'hidden',
  },

  cardContent: {
    flexDirection: 'row',
    minHeight: 120,
  },

  thumbnail: {
    width: 110,
    height: '100%',
    borderTopLeftRadius: borderRadius.xl,
    borderBottomLeftRadius: borderRadius.xl,
  },

  content: {
    flex: 1,
    padding: spacing.md,
    justifyContent: 'space-between',
  },

  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: spacing.xs / 2,
  },

  type: {
    fontSize: typography.fontSize.xs - 1,
    fontWeight: typography.fontWeight.bold,
    letterSpacing: 0.8,
  },

  bookmarkIcon: {
    fontSize: 20,
  },

  title: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.bold,
    marginBottom: spacing.xs,
    lineHeight: typography.fontSize.base * 1.3,
  },

  description: {
    fontSize: typography.fontSize.sm,
    lineHeight: typography.fontSize.sm * 1.4,
    marginBottom: spacing.sm,
  },

  footer: {
    flexDirection: 'row',
    alignItems: 'center',
  },

  duration: {
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.medium,
  },

  separator: {
    fontSize: typography.fontSize.xs,
    marginHorizontal: spacing.xs,
  },

  author: {
    fontSize: typography.fontSize.xs,
    flex: 1,
  },
});
