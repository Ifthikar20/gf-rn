import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, SafeAreaView } from 'react-native';
import { ArticleCard, CategoryPill } from '@components/library';
import { ThemedBackground } from '@components/common';
import { ContentCategory } from '@app-types/index';
import { spacing, typography } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';
import { mockLibraryContent } from '@services/mockData';

const categories: ContentCategory[] = [
  'mindfulness',
  'stress',
  'sleep',
  'anxiety',
  'depression',
  'productivity',
  'relationships',
  'self-care',
];

const categoryLabels: Record<ContentCategory | 'all', string> = {
  all: 'All Content',
  mindfulness: 'Mindfulness',
  stress: 'Stress Relief',
  sleep: 'Better Sleep',
  anxiety: 'Anxiety Support',
  depression: 'Mental Wellness',
  productivity: 'Productivity',
  relationships: 'Relationships',
  'self-care': 'Self Care',
};

export const LibraryScreen: React.FC = () => {
  const colors = useThemedColors();
  const [selectedCategory, setSelectedCategory] = useState<ContentCategory | undefined>();

  // Group content by category
  const contentByCategory: Record<string, typeof mockLibraryContent> = {};

  if (selectedCategory) {
    // If a category is selected, only show that category
    contentByCategory[selectedCategory] = mockLibraryContent.filter(
      (item) => item.category === selectedCategory
    );
  } else {
    // Show all categories
    categories.forEach((category) => {
      const items = mockLibraryContent.filter((item) => item.category === category);
      if (items.length > 0) {
        contentByCategory[category] = items;
      }
    });
  }

  return (
    <ThemedBackground>
      <SafeAreaView style={styles.safeArea}>
        <View style={styles.container}>
          <View style={styles.header}>
            <Text style={[styles.title, { color: colors.text.primary }]}>Library</Text>
            <Text style={[styles.subtitle, { color: colors.text.secondary }]}>Explore wellness content</Text>
          </View>

          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            style={styles.categoriesScroll}
            contentContainerStyle={styles.categoriesContent}
          >
            <CategoryPill
              category={'all' as ContentCategory}
              selected={!selectedCategory}
              onPress={() => setSelectedCategory(undefined)}
            />
            {categories.map((category) => (
              <CategoryPill
                key={category}
                category={category}
                selected={selectedCategory === category}
                onPress={() => setSelectedCategory(category)}
              />
            ))}
          </ScrollView>

          <ScrollView
            style={styles.sectionsContainer}
            showsVerticalScrollIndicator={false}
          >
            {Object.entries(contentByCategory).map(([category, items]) => (
              <View key={category} style={styles.section}>
                <Text style={[styles.sectionTitle, { color: colors.text.primary }]}>
                  {categoryLabels[category as ContentCategory] || category}
                </Text>

                <ScrollView
                  horizontal
                  showsHorizontalScrollIndicator={false}
                  contentContainerStyle={styles.cardsContainer}
                >
                  {items.map((item) => (
                    <ArticleCard
                      key={item.id}
                      item={item}
                      onPress={() => {}}
                      onBookmarkToggle={() => {}}
                    />
                  ))}
                </ScrollView>
              </View>
            ))}
          </ScrollView>
        </View>
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

  categoriesScroll: {
    flexGrow: 0,
    marginBottom: spacing.lg,
  },

  categoriesContent: {
    paddingHorizontal: spacing.screenPadding,
    paddingVertical: spacing.xs,
    alignItems: 'center',
  },

  sectionsContainer: {
    flex: 1,
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

  cardsContainer: {
    paddingLeft: spacing.screenPadding,
    paddingRight: spacing.screenPadding,
  },
});
