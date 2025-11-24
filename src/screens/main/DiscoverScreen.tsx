import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, SafeAreaView, Image, TouchableOpacity, TextInput } from 'react-native';
import { ThemedBackground } from '@components/common';
import { spacing, typography, borderRadius } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';

const discoverSections = [
  {
    id: '1',
    title: 'Trending Now',
    items: [
      {
        id: '1',
        title: 'Mindful Morning Routine',
        image: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400',
        category: 'Mindfulness',
      },
      {
        id: '2',
        title: 'Better Sleep Guide',
        image: 'https://images.unsplash.com/photo-1511295742362-92c96b1cf484?w=400',
        category: 'Sleep',
      },
    ],
  },
  {
    id: '2',
    title: 'Popular Articles',
    items: [
      {
        id: '3',
        title: 'Managing Stress at Work',
        image: 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=400',
        category: 'Stress',
      },
      {
        id: '4',
        title: 'Breathing Techniques',
        image: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400',
        category: 'Anxiety',
      },
    ],
  },
];

export const DiscoverScreen: React.FC = () => {
  const colors = useThemedColors();
  const [searchQuery, setSearchQuery] = useState('');

  return (
    <ThemedBackground>
      <SafeAreaView style={styles.safeArea}>
        <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
          <View style={styles.header}>
            <Text style={[styles.title, { color: colors.text.primary }]}>Discover</Text>
            <Text style={[styles.subtitle, { color: colors.text.secondary }]}>Explore curated wellness content</Text>
          </View>

          {/* Search Bar */}
          <View style={styles.searchContainer}>
            <View style={[styles.searchBar, { backgroundColor: colors.background.primary, borderColor: colors.border.light }]}>
              <Text style={[styles.searchIcon, { color: colors.text.tertiary }]}>🔍</Text>
              <TextInput
                style={[styles.searchInput, { color: colors.text.primary }]}
                placeholder="Search articles, topics..."
                placeholderTextColor={colors.text.tertiary}
                value={searchQuery}
                onChangeText={setSearchQuery}
              />
              {searchQuery.length > 0 && (
                <TouchableOpacity onPress={() => setSearchQuery('')}>
                  <Text style={[styles.clearButton, { color: colors.text.tertiary }]}>✕</Text>
                </TouchableOpacity>
              )}
            </View>
          </View>

          {discoverSections.map((section) => (
            <View key={section.id} style={styles.section}>
              <Text style={[styles.sectionTitle, { color: colors.text.primary }]}>{section.title}</Text>
              <ScrollView
                horizontal
                showsHorizontalScrollIndicator={false}
                contentContainerStyle={styles.itemsContainer}
              >
                {section.items.map((item) => (
                  <TouchableOpacity key={item.id} style={[styles.card, { backgroundColor: colors.background.primary }]} activeOpacity={0.7}>
                    <Image source={{ uri: item.image }} style={styles.cardImage} />
                    <View style={styles.cardContent}>
                      <Text style={[styles.cardCategory, { color: colors.primary.main }]}>{item.category}</Text>
                      <Text style={[styles.cardTitle, { color: colors.text.primary }]} numberOfLines={2}>
                        {item.title}
                      </Text>
                    </View>
                  </TouchableOpacity>
                ))}
              </ScrollView>
            </View>
          ))}
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

  header: {
    padding: spacing.screenPadding,
    paddingBottom: spacing.md,
  },

  title: {
    fontSize: typography.fontSize['3xl'],
    fontWeight: typography.fontWeight.bold,
    marginBottom: spacing.xs,
  },

  subtitle: {
    fontSize: typography.fontSize.base,
  },

  section: {
    marginBottom: spacing.xl,
  },

  sectionTitle: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
    paddingHorizontal: spacing.screenPadding,
    marginBottom: spacing.md,
  },

  itemsContainer: {
    paddingHorizontal: spacing.screenPadding,
    gap: spacing.md,
  },

  searchContainer: {
    paddingHorizontal: spacing.screenPadding,
    marginBottom: spacing.md,
  },

  searchBar: {
    flexDirection: 'row',
    alignItems: 'center',
    borderRadius: borderRadius.md,
    borderWidth: 1,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
  },

  searchIcon: {
    fontSize: typography.fontSize.lg,
    marginRight: spacing.sm,
  },

  searchInput: {
    flex: 1,
    fontSize: typography.fontSize.base,
  },

  clearButton: {
    fontSize: typography.fontSize.xl,
    paddingHorizontal: spacing.xs,
  },

  card: {
    width: 160,
    borderRadius: borderRadius.lg,
    overflow: 'hidden',
  },

  cardImage: {
    width: '100%',
    height: 100,
  },

  cardContent: {
    padding: spacing.sm,
  },

  cardCategory: {
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.medium,
    textTransform: 'uppercase',
    marginBottom: spacing.xs / 2,
  },

  cardTitle: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.semibold,
  },
});
