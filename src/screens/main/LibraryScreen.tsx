import React, { useState } from 'react';
import { View, Text, StyleSheet, FlatList, ScrollView } from 'react-native';
import { useLibrary, useToggleBookmark } from '@hooks/useLibrary';
import { ArticleCard, CategoryPill } from '@components/library';
import { ContentCategory } from '@app-types/index';
import { colors, spacing, typography } from '@theme/index';

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
  const [selectedCategory, setSelectedCategory] = useState<ContentCategory | undefined>();

  const { data: content, isLoading } = useLibrary(
    selectedCategory ? { category: [selectedCategory] } : undefined
  );
  const toggleBookmark = useToggleBookmark();

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Library</Text>
        <Text style={styles.subtitle}>Explore wellness content</Text>
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
        data={content || []}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <ArticleCard
            item={item}
            onPress={() => {}}
            onBookmarkToggle={() =>
              toggleBookmark.mutate({
                contentId: item.id,
                isBookmarked: !item.isBookmarked,
              })
            }
          />
        )}
        contentContainerStyle={styles.listContent}
        ListEmptyComponent={
          <Text style={styles.emptyText}>
            {isLoading ? 'Loading...' : 'No content available'}
          </Text>
        }
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background.secondary,
  },

  header: {
    padding: spacing.screenPadding,
    paddingBottom: spacing.md,
  },

  title: {
    fontSize: typography.fontSize['3xl'],
    fontWeight: typography.fontWeight.bold,
    color: colors.text.primary,
    marginBottom: spacing.xs,
  },

  subtitle: {
    fontSize: typography.fontSize.base,
    color: colors.text.secondary,
  },

  categoriesScroll: {
    maxHeight: 50,
    marginBottom: spacing.md,
  },

  categoriesContent: {
    paddingHorizontal: spacing.screenPadding,
  },

  listContent: {
    padding: spacing.screenPadding,
  },

  emptyText: {
    fontSize: typography.fontSize.base,
    color: colors.text.secondary,
    textAlign: 'center',
    padding: spacing.xl,
  },
});
