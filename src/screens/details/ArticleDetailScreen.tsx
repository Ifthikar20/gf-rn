import React from 'react';
import { View, Text, StyleSheet, ScrollView, Image } from 'react-native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { RouteProp } from '@react-navigation/native';
import { useContentById } from '@hooks/useLibrary';
import { Button, ThemedBackground } from '@components/common';
import { spacing, typography } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';


export const ArticleDetailScreen = ({
  navigation,
  route,
}: {
  navigation: any;
  route: any;
}) => {
  const colors = useThemedColors();
  const { id } = route.params;
  const { data: content, isLoading } = useContentById(id);

  if (isLoading) {
    return (
      <ThemedBackground>
        <View style={styles.centered}>
          <Text style={[styles.loadingText, { color: colors.text.secondary }]}>Loading...</Text>
        </View>
      </ThemedBackground>
    );
  }

  if (!content) {
    return (
      <ThemedBackground>
        <View style={styles.centered}>
          <Text style={[styles.errorText, { color: colors.text.primary }]}>Content not found</Text>
          <Button title="Go Back" onPress={() => navigation.goBack()} />
        </View>
      </ThemedBackground>
    );
  }

  return (
    <ThemedBackground>
      <ScrollView style={styles.container}>
        {content.thumbnail && (
          <Image source={{ uri: content.thumbnail }} style={styles.thumbnail} />
        )}

        <View style={styles.content}>
          <Text style={[styles.category, { color: colors.primary.main }]}>{content.category}</Text>
          <Text style={[styles.title, { color: colors.text.primary }]}>{content.title}</Text>

          {content.author && (
            <Text style={[styles.author, { color: colors.text.secondary }]}>By {content.author}</Text>
          )}

          <Text style={[styles.description, { color: colors.text.primary }]}>{content.description}</Text>

          <View style={styles.tags}>
            {content.tags.map((tag) => (
              <View key={tag} style={[styles.tag, { backgroundColor: colors.background.tertiary }]}>
                <Text style={[styles.tagText, { color: colors.text.secondary }]}>{tag}</Text>
              </View>
            ))}
          </View>
        </View>
      </ScrollView>
    </ThemedBackground>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },

  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: spacing.screenPadding,
  },

  loadingText: {
    fontSize: typography.fontSize.base,
  },

  errorText: {
    fontSize: typography.fontSize.lg,
    marginBottom: spacing.lg,
  },

  thumbnail: {
    width: '100%',
    height: 300,
  },

  content: {
    padding: spacing.screenPadding,
  },

  category: {
    fontSize: typography.fontSize.sm,
    textTransform: 'uppercase',
    fontWeight: typography.fontWeight.semibold,
    marginBottom: spacing.sm,
  },

  title: {
    fontSize: typography.fontSize['3xl'],
    fontWeight: typography.fontWeight.bold,
    marginBottom: spacing.md,
    lineHeight: typography.fontSize['3xl'] * typography.lineHeight.tight,
  },

  author: {
    fontSize: typography.fontSize.sm,
    marginBottom: spacing.lg,
  },

  description: {
    fontSize: typography.fontSize.base,
    lineHeight: typography.fontSize.base * typography.lineHeight.relaxed,
    marginBottom: spacing.lg,
  },

  tags: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.sm,
  },

  tag: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: 20,
  },

  tagText: {
    fontSize: typography.fontSize.xs,
  },
});
