import React from 'react';
import { View, Text, StyleSheet, ScrollView, Image } from 'react-native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { RouteProp } from '@react-navigation/native';
import { useContentById } from '@hooks/useLibrary';
import { Button } from '@components/common';
import { colors, spacing, typography } from '@theme/index';


export const ArticleDetailScreen = ({
  navigation,
  route,
}: {
  navigation: any;
  route: any;
}) => {
  const { id } = route.params;
  const { data: content, isLoading } = useContentById(id);

  if (isLoading) {
    return (
      <View style={styles.centered}>
        <Text style={styles.loadingText}>Loading...</Text>
      </View>
    );
  }

  if (!content) {
    return (
      <View style={styles.centered}>
        <Text style={styles.errorText}>Content not found</Text>
        <Button title="Go Back" onPress={() => navigation.goBack()} />
      </View>
    );
  }

  return (
    <ScrollView style={styles.container}>
      {content.thumbnail && (
        <Image source={{ uri: content.thumbnail }} style={styles.thumbnail} />
      )}

      <View style={styles.content}>
        <Text style={styles.category}>{content.category}</Text>
        <Text style={styles.title}>{content.title}</Text>

        {content.author && (
          <Text style={styles.author}>By {content.author}</Text>
        )}

        <Text style={styles.description}>{content.description}</Text>

        <View style={styles.tags}>
          {content.tags.map((tag) => (
            <View key={tag} style={styles.tag}>
              <Text style={styles.tagText}>{tag}</Text>
            </View>
          ))}
        </View>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background.primary,
  },

  centered: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: spacing.screenPadding,
  },

  loadingText: {
    fontSize: typography.fontSize.base,
    color: colors.text.secondary,
  },

  errorText: {
    fontSize: typography.fontSize.lg,
    color: colors.text.primary,
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
    color: colors.primary.main,
    textTransform: 'uppercase',
    fontWeight: typography.fontWeight.semibold,
    marginBottom: spacing.sm,
  },

  title: {
    fontSize: typography.fontSize['3xl'],
    fontWeight: typography.fontWeight.bold,
    color: colors.text.primary,
    marginBottom: spacing.md,
    lineHeight: typography.fontSize['3xl'] * typography.lineHeight.tight,
  },

  author: {
    fontSize: typography.fontSize.sm,
    color: colors.text.secondary,
    marginBottom: spacing.lg,
  },

  description: {
    fontSize: typography.fontSize.base,
    color: colors.text.primary,
    lineHeight: typography.fontSize.base * typography.lineHeight.relaxed,
    marginBottom: spacing.lg,
  },

  tags: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: spacing.sm,
  },

  tag: {
    backgroundColor: colors.background.tertiary,
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
    borderRadius: 20,
  },

  tagText: {
    fontSize: typography.fontSize.xs,
    color: colors.text.secondary,
  },
});
