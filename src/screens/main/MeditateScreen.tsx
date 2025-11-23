import React from 'react';
import { View, Text, StyleSheet, FlatList, SafeAreaView } from 'react-native';
import { ArticleCard } from '@components/library';
import { colors, spacing, typography } from '@theme/index';
import { mockMeditationContent } from '@services/mockData';

export const MeditateScreen: React.FC = () => {
  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        <View style={styles.header}>
          <Text style={styles.title}>Meditate</Text>
          <Text style={styles.subtitle}>Find your inner peace</Text>
        </View>

        <FlatList
          data={mockMeditationContent}
          keyExtractor={(item) => item.id}
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

  listContent: {
    padding: spacing.screenPadding,
  },
});
