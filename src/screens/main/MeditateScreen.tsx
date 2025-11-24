import React from 'react';
import { View, Text, StyleSheet, FlatList, SafeAreaView, Image, TouchableOpacity } from 'react-native';
import { ThemedBackground } from '@components/common';
import { spacing, typography, borderRadius } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';

interface MeditationCategory {
  id: string;
  title: string;
  description: string;
  image: string;
  audioUrl: string;
}

const meditationCategories: MeditationCategory[] = [
  {
    id: '1',
    title: 'Sounds of Nature',
    description: 'Relaxing natural soundscapes',
    image: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
    audioUrl: 'https://example.com/nature-sounds.mp3',
  },
  {
    id: '2',
    title: 'Ocean Waves',
    description: 'Calming ocean sounds',
    image: 'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=800',
    audioUrl: 'https://example.com/ocean-waves.mp3',
  },
  {
    id: '3',
    title: 'Rain Sounds',
    description: 'Gentle rainfall ambience',
    image: 'https://images.unsplash.com/photo-1428908728789-d2de25dbd4e2?w=800',
    audioUrl: 'https://example.com/rain-sounds.mp3',
  },
  {
    id: '4',
    title: 'Forest Ambience',
    description: 'Peaceful forest sounds',
    image: 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=800',
    audioUrl: 'https://example.com/forest-ambience.mp3',
  },
  {
    id: '5',
    title: 'Guided Meditation',
    description: 'Voice-guided meditation sessions',
    image: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
    audioUrl: 'https://example.com/guided-meditation.mp3',
  },
  {
    id: '6',
    title: 'Sleep Sounds',
    description: 'Soothing sounds for better sleep',
    image: 'https://images.unsplash.com/photo-1511295742362-92c96b1cf484?w=800',
    audioUrl: 'https://example.com/sleep-sounds.mp3',
  },
  {
    id: '7',
    title: 'Mindfulness Practice',
    description: 'Present moment awareness exercises',
    image: 'https://images.unsplash.com/photo-1545389336-cf090694435e?w=800',
    audioUrl: 'https://example.com/mindfulness.mp3',
  },
  {
    id: '8',
    title: 'Breathing Exercises',
    description: 'Focused breathing techniques',
    image: 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=800',
    audioUrl: 'https://example.com/breathing.mp3',
  },
  {
    id: '9',
    title: 'Chakra Meditation',
    description: 'Energy center balancing',
    image: 'https://images.unsplash.com/photo-1528715471579-d1bcf0ba5e83?w=800',
    audioUrl: 'https://example.com/chakra.mp3',
  },
  {
    id: '10',
    title: 'White Noise',
    description: 'Consistent ambient sound for focus',
    image: 'https://images.unsplash.com/photo-1483086431886-3590a88317fe?w=800',
    audioUrl: 'https://example.com/white-noise.mp3',
  },
  {
    id: '11',
    title: 'Thunderstorm',
    description: 'Powerful storm sounds',
    image: 'https://images.unsplash.com/photo-1605727216801-e27ce1d0cc28?w=800',
    audioUrl: 'https://example.com/thunderstorm.mp3',
  },
  {
    id: '12',
    title: 'Mountain Zen',
    description: 'High altitude tranquility',
    image: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
    audioUrl: 'https://example.com/mountain-zen.mp3',
  },
];

interface MeditateScreenProps {
  navigation?: any;
}

export const MeditateScreen: React.FC<MeditateScreenProps> = ({ navigation }) => {
  const colors = useThemedColors();

  const handleCategoryPress = (category: MeditationCategory) => {
    // Navigate to audio player
    navigation?.navigate('AudioPlayer', { category });
  };

  return (
    <ThemedBackground>
      <SafeAreaView style={styles.safeArea}>
        <View style={styles.container}>
          <View style={styles.header}>
            <Text style={[styles.title, { color: colors.text.primary }]}>Meditate</Text>
            <Text style={[styles.subtitle, { color: colors.text.secondary }]}>Choose your meditation sound</Text>
          </View>

          <FlatList
            data={meditationCategories}
            keyExtractor={(item) => item.id}
            renderItem={({ item }) => (
              <TouchableOpacity
                style={styles.categoryCard}
                onPress={() => handleCategoryPress(item)}
                activeOpacity={0.7}
              >
                <Image source={{ uri: item.image }} style={styles.categoryImage} />
                <View style={styles.categoryOverlay}>
                  <Text style={[styles.categoryTitle, { color: colors.text.inverse }]}>{item.title}</Text>
                  <Text style={[styles.categoryDescription, { color: colors.text.inverse }]}>{item.description}</Text>
                </View>
              </TouchableOpacity>
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

  listContent: {
    padding: spacing.screenPadding,
    paddingTop: 0,
  },

  categoryCard: {
    width: '100%',
    height: 180,
    marginBottom: spacing.md,
    borderRadius: borderRadius.lg,
    overflow: 'hidden',
    position: 'relative',
  },

  categoryImage: {
    width: '100%',
    height: '100%',
  },

  categoryOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: 'rgba(0, 0, 0, 0.6)',
    padding: spacing.md,
  },

  categoryTitle: {
    fontSize: typography.fontSize.lg,
    fontWeight: typography.fontWeight.semibold,
    marginBottom: spacing.xs / 2,
  },

  categoryDescription: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.normal,
    opacity: 0.9,
  },
});
