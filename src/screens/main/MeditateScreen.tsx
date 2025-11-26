import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  Image,
  TouchableOpacity,
  ImageBackground,
  Dimensions,
} from 'react-native';
import { spacing, typography, borderRadius } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';

const { width: SCREEN_WIDTH } = Dimensions.get('window');
const CARD_WIDTH = 160;
const LARGE_CARD_WIDTH = 200;

interface MeditationCategory {
  id: string;
  title: string;
  description: string;
  author?: string;
  image: string;
  audioUrl: string;
  videoUrl?: string;
  featured?: boolean;
}

const meditationCategories: MeditationCategory[] = [
  {
    id: '1',
    title: 'Sounds of Nature',
    description: 'Relaxing natural soundscapes',
    author: 'Nature Studio',
    image: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
    audioUrl: 'https://example.com/nature-sounds.mp3',
  },
  {
    id: '2',
    title: 'Ocean Waves',
    description: 'Calming ocean sounds',
    author: 'Peaceful Sounds',
    image: 'https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=800',
    audioUrl: 'https://example.com/ocean-waves.mp3',
    featured: true,
  },
  {
    id: '3',
    title: 'Rain Sounds',
    description: 'Gentle rainfall ambience',
    author: 'Tranquil Audio',
    image: 'https://images.unsplash.com/photo-1428908728789-d2de25dbd4e2?w=800',
    audioUrl: 'https://example.com/rain-sounds.mp3',
    videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    featured: true,
  },
  {
    id: '4',
    title: 'Forest Ambience',
    description: 'Peaceful forest sounds',
    author: 'Nature Studio',
    image: 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=800',
    audioUrl: 'https://example.com/forest-ambience.mp3',
  },
  {
    id: '5',
    title: 'Guided Meditation',
    description: 'Voice-guided meditation sessions',
    author: 'Mindful Masters',
    image: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800',
    audioUrl: 'https://example.com/guided-meditation.mp3',
    featured: true,
  },
  {
    id: '6',
    title: 'Sleep Sounds',
    description: 'Soothing sounds for better sleep',
    author: 'Dream Escapes',
    image: 'https://images.unsplash.com/photo-1511295742362-92c96b1cf484?w=800',
    audioUrl: 'https://example.com/sleep-sounds.mp3',
  },
  {
    id: '7',
    title: 'Mindfulness Practice',
    description: 'Present moment awareness exercises',
    author: 'Zen Collective',
    image: 'https://images.unsplash.com/photo-1545389336-cf090694435e?w=800',
    audioUrl: 'https://example.com/mindfulness.mp3',
  },
  {
    id: '8',
    title: 'Breathing Exercises',
    description: 'Focused breathing techniques',
    author: 'Calm Breathwork',
    image: 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=800',
    audioUrl: 'https://example.com/breathing.mp3',
  },
  {
    id: '9',
    title: 'Chakra Meditation',
    description: 'Energy center balancing',
    author: 'Spiritual Journey',
    image: 'https://images.unsplash.com/photo-1528715471579-d1bcf0ba5e83?w=800',
    audioUrl: 'https://example.com/chakra.mp3',
    featured: true,
  },
  {
    id: '10',
    title: 'White Noise',
    description: 'Consistent ambient sound for focus',
    author: 'Focus Sounds',
    image: 'https://images.unsplash.com/photo-1483086431886-3590a88317fe?w=800',
    audioUrl: 'https://example.com/white-noise.mp3',
  },
  {
    id: '11',
    title: 'Thunderstorm',
    description: 'Powerful storm sounds',
    author: 'Storm Collective',
    image: 'https://images.unsplash.com/photo-1605727216801-e27ce1d0cc28?w=800',
    audioUrl: 'https://example.com/thunderstorm.mp3',
  },
  {
    id: '12',
    title: 'Mountain Zen',
    description: 'High altitude tranquility',
    author: 'Peak Meditation',
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
    navigation?.navigate('AudioPlayer', { category });
  };

  // Group content by sections
  const featuredContent = meditationCategories.filter((c) => c.featured);
  const popularContent = meditationCategories.slice(0, 6);
  const editorsPicksContent = meditationCategories.slice(3, 9);

  return (
    <View style={styles.container}>
      <ScrollView
        style={styles.scrollView}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={styles.scrollContent}
      >
        {/* Hero Section */}
        <ImageBackground
          source={{ uri: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1200' }}
          style={styles.heroSection}
          resizeMode="cover"
        >
          <View style={styles.heroOverlay} />
          <SafeAreaView style={styles.heroContent}>
            <TouchableOpacity style={styles.backButton} onPress={() => navigation?.goBack()}>
              <Text style={styles.backIcon}>←</Text>
            </TouchableOpacity>
            <View style={styles.heroTextContainer}>
              <Text style={styles.heroTitle}>Relaxation Sounds</Text>
            </View>
          </SafeAreaView>
        </ImageBackground>

        {/* Featured Sessions Section */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: colors.text.primary }]}>
            Featured sessions
          </Text>
          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={styles.cardsContainer}
          >
            {featuredContent.map((item) => (
              <TouchableOpacity
                key={item.id}
                style={styles.largeCard}
                onPress={() => handleCategoryPress(item)}
                activeOpacity={0.8}
              >
                <Image source={{ uri: item.image }} style={styles.largeCardImage} />
                <View style={styles.largeCardInfo}>
                  <Text
                    style={[styles.largeCardTitle, { color: colors.text.primary }]}
                    numberOfLines={2}
                  >
                    {item.title}
                  </Text>
                  <Text style={[styles.largeCardAuthor, { color: colors.text.secondary }]}>
                    {item.author}
                  </Text>
                </View>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        {/* Popular This Week Section */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: colors.text.primary }]}>
            Popular this week
          </Text>
          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={styles.cardsContainer}
          >
            {popularContent.map((item) => (
              <TouchableOpacity
                key={item.id}
                style={styles.card}
                onPress={() => handleCategoryPress(item)}
                activeOpacity={0.8}
              >
                <Image source={{ uri: item.image }} style={styles.cardImage} />
                <View style={styles.cardInfo}>
                  <Text style={[styles.cardTitle, { color: colors.text.primary }]} numberOfLines={2}>
                    {item.title}
                  </Text>
                  <Text style={[styles.cardAuthor, { color: colors.text.secondary }]}>
                    {item.author}
                  </Text>
                </View>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        {/* Editors' Picks Section */}
        <View style={styles.section}>
          <Text style={[styles.sectionTitle, { color: colors.text.primary }]}>
            Editors' picks
          </Text>
          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={styles.cardsContainer}
          >
            {editorsPicksContent.map((item) => (
              <TouchableOpacity
                key={item.id}
                style={styles.card}
                onPress={() => handleCategoryPress(item)}
                activeOpacity={0.8}
              >
                <Image source={{ uri: item.image }} style={styles.cardImage} />
                <View style={styles.cardInfo}>
                  <Text style={[styles.cardTitle, { color: colors.text.primary }]} numberOfLines={2}>
                    {item.title}
                  </Text>
                  <Text style={[styles.cardAuthor, { color: colors.text.secondary }]}>
                    {item.author}
                  </Text>
                </View>
              </TouchableOpacity>
            ))}
          </ScrollView>
        </View>

        <View style={styles.bottomPadding} />
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000000',
  },

  scrollView: {
    flex: 1,
  },

  scrollContent: {
    paddingBottom: spacing.xl,
  },

  // Hero Section
  heroSection: {
    height: 400,
    width: '100%',
    position: 'relative',
  },

  heroOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0, 0, 0, 0.4)',
  },

  heroContent: {
    flex: 1,
    justifyContent: 'space-between',
  },

  backButton: {
    marginLeft: spacing.screenPadding,
    marginTop: spacing.sm,
    width: 40,
    height: 40,
    alignItems: 'center',
    justifyContent: 'center',
  },

  backIcon: {
    fontSize: 28,
    color: '#FFFFFF',
    fontWeight: typography.fontWeight.medium,
  },

  heroTextContainer: {
    paddingHorizontal: spacing.screenPadding,
    paddingBottom: spacing.xl,
  },

  heroTitle: {
    fontSize: 48,
    fontWeight: typography.fontWeight.bold,
    color: '#FFFFFF',
    textShadowColor: 'rgba(0, 0, 0, 0.75)',
    textShadowOffset: { width: 0, height: 2 },
    textShadowRadius: 8,
  },

  // Section Styles
  section: {
    marginTop: spacing.xl,
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

  // Large Card (Featured - 200x200)
  largeCard: {
    width: LARGE_CARD_WIDTH,
  },

  largeCardImage: {
    width: LARGE_CARD_WIDTH,
    height: LARGE_CARD_WIDTH,
    borderRadius: borderRadius.md,
    marginBottom: spacing.sm,
  },

  largeCardInfo: {
    gap: spacing.xs / 2,
  },

  largeCardTitle: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.semibold,
    lineHeight: typography.fontSize.base * 1.3,
  },

  largeCardAuthor: {
    fontSize: typography.fontSize.sm,
  },

  // Regular Card (160x160)
  card: {
    width: CARD_WIDTH,
  },

  cardImage: {
    width: CARD_WIDTH,
    height: CARD_WIDTH,
    borderRadius: borderRadius.md,
    marginBottom: spacing.sm,
  },

  cardInfo: {
    gap: spacing.xs / 2,
  },

  cardTitle: {
    fontSize: typography.fontSize.sm,
    fontWeight: typography.fontWeight.semibold,
    lineHeight: typography.fontSize.sm * 1.3,
  },

  cardAuthor: {
    fontSize: typography.fontSize.xs,
  },

  bottomPadding: {
    height: spacing.xl,
  },
});
