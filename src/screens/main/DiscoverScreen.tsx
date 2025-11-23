import React from 'react';
import { View, Text, StyleSheet, ScrollView, SafeAreaView, Image, TouchableOpacity } from 'react-native';
import { colors, spacing, typography, borderRadius } from '@theme/index';

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
  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
        <View style={styles.header}>
          <Text style={styles.title}>Discover</Text>
          <Text style={styles.subtitle}>Explore curated wellness content</Text>
        </View>

        {discoverSections.map((section) => (
          <View key={section.id} style={styles.section}>
            <Text style={styles.sectionTitle}>{section.title}</Text>
            <ScrollView
              horizontal
              showsHorizontalScrollIndicator={false}
              contentContainerStyle={styles.itemsContainer}
            >
              {section.items.map((item) => (
                <TouchableOpacity key={item.id} style={styles.card} activeOpacity={0.7}>
                  <Image source={{ uri: item.image }} style={styles.cardImage} />
                  <View style={styles.cardContent}>
                    <Text style={styles.cardCategory}>{item.category}</Text>
                    <Text style={styles.cardTitle} numberOfLines={2}>
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
  );
};

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: colors.background.secondary,
  },

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

  section: {
    marginBottom: spacing.xl,
  },

  sectionTitle: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
    color: colors.text.primary,
    paddingHorizontal: spacing.screenPadding,
    marginBottom: spacing.md,
  },

  itemsContainer: {
    paddingHorizontal: spacing.screenPadding,
    gap: spacing.md,
  },

  card: {
    width: 200,
    backgroundColor: colors.background.primary,
    borderRadius: borderRadius.lg,
    overflow: 'hidden',
  },

  cardImage: {
    width: '100%',
    height: 120,
  },

  cardContent: {
    padding: spacing.md,
  },

  cardCategory: {
    fontSize: typography.fontSize.xs,
    fontWeight: typography.fontWeight.medium,
    color: colors.primary.main,
    textTransform: 'uppercase',
    marginBottom: spacing.xs / 2,
  },

  cardTitle: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.semibold,
    color: colors.text.primary,
  },
});
