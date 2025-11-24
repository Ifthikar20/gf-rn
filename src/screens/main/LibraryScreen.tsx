import React, { useState } from 'react';
import { View, Text, StyleSheet, FlatList, ScrollView, SafeAreaView } from 'react-native';
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

export const LibraryScreen: React.FC = () => {
  const colors = useThemedColors();
  const [selectedCategory, setSelectedCategory] = useState<ContentCategory | undefined>();

  // Filter mock data by category
  const content = selectedCategory
    ? mockLibraryContent.filter((item) => item.category === selectedCategory)
    : mockLibraryContent;

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

          <FlatList
            data={content}
            keyExtractor={(item) => item.id}
            numColumns={2}
            columnWrapperStyle={styles.row}
            renderItem={({ item }) => (
              <ArticleCard
                item={item}
                onPress={() => {}}
                onBookmarkToggle={() => {}}
              />
            )}
            contentContainerStyle={styles.listContent}
            showsVerticalScrollIndicator={false}
          />
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
    marginBottom: spacing.md,
  },

  categoriesContent: {
    paddingHorizontal: spacing.screenPadding,
    paddingVertical: spacing.sm,
  },

  listContent: {
    padding: spacing.screenPadding,
    paddingTop: 0,
  },

  row: {
    justifyContent: 'space-between',
  },

  emptyText: {
    fontSize: typography.fontSize.base,
    textAlign: 'center',
    padding: spacing.xl,
  },
});
