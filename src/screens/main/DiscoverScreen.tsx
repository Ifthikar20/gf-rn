import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  Image,
  TouchableOpacity,
  Dimensions,
} from 'react-native';
import { ThemedBackground } from '@components/common';
import { spacing, typography, borderRadius } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';
import { mockLibraryContent } from '@services/mockData';
import { ContentType, ContentCategory } from '@app-types/index';

const { width: SCREEN_WIDTH } = Dimensions.get('window');
const CARD_WIDTH = (SCREEN_WIDTH - spacing.screenPadding * 2 - spacing.md * 2) / 3;

// Filter categories for the top
const filterCategories: Array<'all' | ContentType> = ['all', 'article', 'video', 'audio', 'meditation'];
const filterLabels: Record<'all' | ContentType, string> = {
  all: 'All',
  article: 'Articles',
  video: 'Videos',
  audio: 'Audio',
  meditation: 'Meditations',
};

// Category colors for the wellness cards (matching Spotify's colorful cards)
const categoryColors: Record<ContentCategory, string> = {
  mindfulness: '#E8B4F9',
  stress: '#FFB4A2',
  sleep: '#A7C7E7',
  anxiety: '#FFE5B4',
  depression: '#B4E7D8',
  productivity: '#F9D4A8',
  relationships: '#FFB4D9',
  'self-care': '#D4E7F9',
};

export const DiscoverScreen: React.FC = () => {
  const colors = useThemedColors();
  const [selectedFilter, setSelectedFilter] = useState<'all' | ContentType>('all');

  // Filter content based on selected filter
  const filteredContent = selectedFilter === 'all'
    ? mockLibraryContent
    : mockLibraryContent.filter(item => item.type === selectedFilter);

  // Group content for different sections
  const popularWellness = filteredContent
    .filter(item => item.viewCount > 3000)
    .slice(0, 5);

  // Trending authors with proper profile images
  const authorImages = [
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop', // Woman with red lipstick
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop', // Man in white shirt
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&h=400&fit=crop', // Woman smiling
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop', // Man with glasses
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&h=400&fit=crop', // Woman outdoors
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop', // Man in denim
  ];

  const trendingAuthors = Array.from(
    new Set(filteredContent.map(item => item.author).filter(Boolean))
  )
    .slice(0, 6)
    .map((author, index) => ({
      id: `author-${index}`,
      name: author!,
      image: authorImages[index % authorImages.length],
    }));

  const featuredContent = filteredContent
    .filter(item => item.isBookmarked || item.viewCount > 5000)
    .slice(0, 6);

  const recentlyAdded = filteredContent
    .sort((a, b) => new Date(b.publishedAt).getTime() - new Date(a.publishedAt).getTime())
    .slice(0, 6);

  return (
    <ThemedBackground>
      <SafeAreaView style={styles.safeArea}>
        <ScrollView
          style={styles.container}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={styles.scrollContent}
        >
          {/* Top Filter Pills */}
          <View style={styles.filterContainer}>
            {/* Profile Avatar Circle */}
            <TouchableOpacity style={styles.profileCircle}>
              <Text style={styles.profileText}>W</Text>
            </TouchableOpacity>

            {/* Filter Pills */}
            <ScrollView
              horizontal
              showsHorizontalScrollIndicator={false}
              style={styles.filtersScroll}
              contentContainerStyle={styles.filtersContent}
            >
              {filterCategories.map((category) => (
                <TouchableOpacity
                  key={category}
                  style={[
                    styles.filterPill,
                    selectedFilter === category && {
                      backgroundColor: colors.primary.main,
                    },
                    selectedFilter !== category && {
                      backgroundColor: colors.background.tertiary,
                    },
                  ]}
                  onPress={() => setSelectedFilter(category)}
                  activeOpacity={0.7}
                >
                  <Text
                    style={[
                      styles.filterText,
                      {
                        color: selectedFilter === category ? '#FFFFFF' : colors.text.primary,
                      },
                    ]}
                  >
                    {filterLabels[category]}
                  </Text>
                </TouchableOpacity>
              ))}
            </ScrollView>
          </View>

          {/* Popular Wellness Section */}
          {popularWellness.length > 0 && (
            <View style={styles.section}>
              <Text style={[styles.sectionTitle, { color: colors.text.primary }]}>
                Popular wellness
              </Text>
              <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.cardsContainer}
              >
                {popularWellness.map((item) => (
                  <TouchableOpacity
                    key={item.id}
                    style={[
                      styles.wellnessCard,
                      { backgroundColor: categoryColors[item.category] },
                    ]}
                    activeOpacity={0.8}
                  >
                    {/* Type Badge */}
                    <View style={styles.typeBadge}>
                      <Text style={styles.typeBadgeText}>
                        {item.type.toUpperCase()}
                      </Text>
                    </View>

                    {/* Content Image */}
                    {item.thumbnail && (
                      <View style={styles.wellnessImageContainer}>
                        <Image
                          source={{ uri: item.thumbnail }}
                          style={styles.wellnessImage}
                        />
                      </View>
                    )}

                    {/* Title */}
                    <Text style={styles.wellnessTitle} numberOfLines={2}>
                      {item.title}
                    </Text>

                    {/* Category */}
                    <Text style={styles.wellnessCategory}>
                      {item.category}
                    </Text>

                    {/* Views */}
                    <Text style={styles.wellnessViews}>
                      {item.viewCount.toLocaleString()} views
                    </Text>
                  </TouchableOpacity>
                ))}
              </ScrollView>
            </View>
          )}

          {/* Trending Authors Section */}
          {trendingAuthors.length > 0 && (
            <View style={styles.section}>
              <Text style={[styles.sectionTitle, { color: colors.text.primary }]}>
                Trending authors
              </Text>
              <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.cardsContainer}
              >
                {trendingAuthors.map((author) => (
                  <TouchableOpacity
                    key={author.id}
                    style={styles.authorCard}
                    activeOpacity={0.8}
                  >
                    <Image
                      source={{ uri: author.image }}
                      style={styles.authorImage}
                    />
                    <Text
                      style={[styles.authorName, { color: colors.text.primary }]}
                      numberOfLines={2}
                    >
                      {author.name}
                    </Text>
                  </TouchableOpacity>
                ))}
              </ScrollView>
            </View>
          )}

          {/* Featured Content Section */}
          {featuredContent.length > 0 && (
            <View style={styles.section}>
              <Text style={[styles.sectionTitle, { color: colors.text.primary }]}>
                Featured content
              </Text>
              <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.cardsContainer}
              >
                {featuredContent.map((item) => (
                  <TouchableOpacity
                    key={item.id}
                    style={styles.featuredCard}
                    activeOpacity={0.8}
                  >
                    <Image
                      source={{ uri: item.thumbnail }}
                      style={styles.featuredImage}
                    />
                    <View style={styles.featuredInfo}>
                      <Text
                        style={[styles.featuredTitle, { color: colors.text.primary }]}
                        numberOfLines={2}
                      >
                        {item.title}
                      </Text>
                      <Text style={[styles.featuredAuthor, { color: colors.text.secondary }]}>
                        {item.author}
                      </Text>
                    </View>
                  </TouchableOpacity>
                ))}
              </ScrollView>
            </View>
          )}

          {/* Recently Added Section */}
          {recentlyAdded.length > 0 && (
            <View style={styles.section}>
              <Text style={[styles.sectionTitle, { color: colors.text.primary }]}>
                Recently added
              </Text>
              <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.cardsContainer}
              >
                {recentlyAdded.map((item) => (
                  <TouchableOpacity
                    key={item.id}
                    style={styles.recentCard}
                    activeOpacity={0.8}
                  >
                    <Image
                      source={{ uri: item.thumbnail }}
                      style={styles.recentImage}
                    />
                    <View style={styles.recentInfo}>
                      <Text
                        style={[styles.recentTitle, { color: colors.text.primary }]}
                        numberOfLines={1}
                      >
                        {item.title}
                      </Text>
                      <Text style={[styles.recentMeta, { color: colors.text.tertiary }]}>
                        {item.type} • {item.duration ? `${Math.floor(item.duration / 60)} min` : `${item.readTime} min read`}
                      </Text>
                    </View>
                  </TouchableOpacity>
                ))}
              </ScrollView>
            </View>
          )}
        </ScrollView>
      </SafeAreaView>
    </ThemedBackground>
  );
};

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
  },

  container: {
    flex: 1,
  },

  scrollContent: {
    paddingBottom: spacing.xxxl,
  },

  // ===== FILTER SECTION =====
  filterContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: spacing.md,
    paddingLeft: spacing.screenPadding,
  },

  profileCircle: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: '#10B981',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: spacing.sm,
  },

  profileText: {
    color: '#FFFFFF',
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.bold,
  },

  filtersScroll: {
    flex: 1,
  },

  filtersContent: {
    paddingRight: spacing.screenPadding,
    gap: spacing.sm,
  },

  filterPill: {
    paddingHorizontal: spacing.lg,
    paddingVertical: spacing.sm,
    borderRadius: borderRadius.full,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
  },

  filterText: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.semibold,
  },

  // ===== SECTIONS =====
  section: {
    marginTop: spacing.lg,
  },

  sectionTitle: {
    fontSize: typography.fontSize.xl,
    fontWeight: typography.fontWeight.bold,
    paddingHorizontal: spacing.screenPadding,
    marginBottom: spacing.md,
  },

  cardsContainer: {
    paddingHorizontal: spacing.screenPadding,
    gap: spacing.md,
  },

  // ===== WELLNESS CARDS (Colorful Rectangle Cards) =====
  wellnessCard: {
    width: 160,
    height: 220,
    borderRadius: borderRadius.lg,
    padding: spacing.sm,
    position: 'relative',
    overflow: 'hidden',
  },

  typeBadge: {
    position: 'absolute',
    top: spacing.sm,
    right: spacing.sm,
    backgroundColor: 'rgba(0, 0, 0, 0.15)',
    paddingHorizontal: spacing.sm,
    paddingVertical: spacing.xs / 2,
    borderRadius: borderRadius.sm,
  },

  typeBadgeText: {
    color: '#000000',
    fontSize: 10,
    fontWeight: typography.fontWeight.bold,
    letterSpacing: 0.5,
  },

  wellnessImageContainer: {
    marginTop: spacing.md,
    marginBottom: spacing.sm,
    alignItems: 'center',
  },

  wellnessImage: {
    width: 80,
    height: 80,
    borderRadius: 40,
    borderWidth: 2,
    borderColor: 'rgba(255, 255, 255, 0.3)',
  },

  wellnessTitle: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.bold,
    color: '#000000',
    marginBottom: spacing.xs / 2,
    lineHeight: typography.fontSize.base * 1.3,
  },

  wellnessCategory: {
    fontSize: typography.fontSize.xs,
    color: '#000000',
    opacity: 0.7,
    textTransform: 'capitalize',
    marginBottom: spacing.xs / 2,
  },

  wellnessViews: {
    fontSize: typography.fontSize.xs,
    color: '#000000',
    opacity: 0.6,
  },

  // ===== AUTHOR CARDS (Circular Images) =====
  authorCard: {
    width: 110,
    alignItems: 'center',
  },

  authorImage: {
    width: 110,
    height: 110,
    borderRadius: 55,
    marginBottom: spacing.sm,
  },

  authorName: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.semibold,
    textAlign: 'center',
  },

  // ===== FEATURED CARDS (Square Images with Info) =====
  featuredCard: {
    width: 140,
  },

  featuredImage: {
    width: 140,
    height: 140,
    borderRadius: borderRadius.md,
    marginBottom: spacing.sm,
  },

  featuredInfo: {
    gap: spacing.xs / 2,
  },

  featuredTitle: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.semibold,
    lineHeight: typography.fontSize.sm * 1.3,
  },

  featuredAuthor: {
    fontSize: typography.fontSize.xs,
  },

  // ===== RECENT CARDS (Horizontal Layout) =====
  recentCard: {
    width: 240,
    flexDirection: 'row',
    gap: spacing.sm,
  },

  recentImage: {
    width: 80,
    height: 80,
    borderRadius: borderRadius.md,
  },

  recentInfo: {
    flex: 1,
    justifyContent: 'center',
    gap: spacing.xs / 2,
  },

  recentTitle: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.semibold,
  },

  recentMeta: {
    fontSize: typography.fontSize.xs,
    textTransform: 'capitalize',
  },
});
