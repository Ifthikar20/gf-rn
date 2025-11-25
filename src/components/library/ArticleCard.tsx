import React from 'react';
import { View, Text, Image, StyleSheet, TouchableOpacity } from 'react-native';
import { spacing, typography, borderRadius } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';
import { ContentItem } from '@app-types/index';

// Smaller Spotify-style card
const CARD_WIDTH = 130;

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
    <TouchableOpacity onPress={onPress} activeOpacity={0.7} style={styles.container}>
      <View style={[styles.card, { backgroundColor: colors.background.secondary }]}>
        {/* Full Image */}
        {item.thumbnail && (
          <Image source={{ uri: item.thumbnail }} style={styles.image} />
        )}

        {/* Bookmark Icon - Top Right */}
        <TouchableOpacity
          onPress={onBookmarkToggle}
          style={styles.bookmarkButton}
          hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
        >
          <Text style={styles.bookmarkIcon}>
            {item.isBookmarked ? '★' : '☆'}
          </Text>
        </TouchableOpacity>

        {/* Bottom Overlay with Title and Info */}
        <View style={styles.overlay}>
          <Text style={styles.title} numberOfLines={2}>
            {item.title}
          </Text>

          <View style={styles.metaInfo}>
            <Text style={styles.type}>{item.type.toUpperCase()}</Text>
            {getDuration() && (
              <>
                <Text style={styles.separator}>•</Text>
                <Text style={styles.duration}>{getDuration()}</Text>
              </>
            )}
          </View>
        </View>
      </View>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  container: {
    width: CARD_WIDTH,
    marginRight: spacing.md,
  },

  card: {
    borderRadius: borderRadius.lg,
    overflow: 'hidden',
    aspectRatio: 0.75, // Compact Spotify-style
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.12,
    shadowRadius: 6,
    elevation: 4,
  },

  image: {
    width: '100%',
    height: '100%',
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },

  bookmarkButton: {
    position: 'absolute',
    top: spacing.xs,
    right: spacing.xs,
    width: 28,
    height: 28,
    borderRadius: 14,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 2,
  },

  bookmarkIcon: {
    fontSize: 16,
    color: '#FFFFFF',
  },

  overlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: spacing.sm,
    paddingTop: spacing.lg,
    background: 'linear-gradient(to top, rgba(0, 0, 0, 0.8), transparent)',
    // React Native fallback for gradient
    backgroundColor: 'rgba(0, 0, 0, 0.6)',
  },

  title: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.bold,
    color: '#FFFFFF',
    marginBottom: spacing.xs / 2,
    lineHeight: typography.fontSize.sm * 1.3,
  },

  metaInfo: {
    flexDirection: 'row',
    alignItems: 'center',
  },

  type: {
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.semibold,
    color: '#FFFFFF',
    opacity: 0.9,
    letterSpacing: 0.5,
  },

  separator: {
    fontSize: typography.fontSize.xs,
    color: '#FFFFFF',
    opacity: 0.7,
    marginHorizontal: spacing.xs / 2,
  },

  duration: {
    fontSize: typography.fontSize.xs,
    color: '#FFFFFF',
    opacity: 0.9,
  },
});
