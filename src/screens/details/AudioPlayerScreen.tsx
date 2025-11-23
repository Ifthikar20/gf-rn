import React, { useState } from 'react';
import { View, Text, StyleSheet, SafeAreaView, Image, TouchableOpacity } from 'react-native';
import { colors, spacing, typography, borderRadius } from '@theme/index';

interface AudioPlayerScreenProps {
  route: {
    params: {
      category: {
        id: string;
        title: string;
        description: string;
        image: string;
        audioUrl: string;
      };
    };
  };
  navigation: any;
}

export const AudioPlayerScreen: React.FC<AudioPlayerScreenProps> = ({ route, navigation }) => {
  const { category } = route.params;
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const totalTime = 600; // 10 minutes in seconds

  const handlePlayPause = () => {
    setIsPlaying(!isPlaying);
    // In a real app, you would integrate with an audio library here
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const progress = totalTime > 0 ? (currentTime / totalTime) * 100 : 0;

  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={styles.container}>
        <TouchableOpacity style={styles.backButton} onPress={() => navigation.goBack()}>
          <Text style={styles.backText}>← Back</Text>
        </TouchableOpacity>

        <View style={styles.content}>
          <Image source={{ uri: category.image }} style={styles.coverImage} />

          <View style={styles.info}>
            <Text style={styles.title}>{category.title}</Text>
            <Text style={styles.description}>{category.description}</Text>
          </View>

          <View style={styles.progressContainer}>
            <View style={styles.progressBar}>
              <View style={[styles.progressFill, { width: `${progress}%` }]} />
            </View>
            <View style={styles.timeLabels}>
              <Text style={styles.timeText}>{formatTime(currentTime)}</Text>
              <Text style={styles.timeText}>{formatTime(totalTime)}</Text>
            </View>
          </View>

          <View style={styles.controls}>
            <TouchableOpacity style={styles.playButton} onPress={handlePlayPause}>
              <Text style={styles.playButtonText}>{isPlaying ? '❚❚' : '▶'}</Text>
            </TouchableOpacity>
          </View>
        </View>
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

  backButton: {
    padding: spacing.md,
    paddingLeft: spacing.screenPadding,
  },

  backText: {
    fontSize: typography.fontSize.base,
    color: colors.primary.main,
    fontWeight: typography.fontWeight.medium,
  },

  content: {
    flex: 1,
    alignItems: 'center',
    paddingHorizontal: spacing.screenPadding,
    paddingTop: spacing.xl,
  },

  coverImage: {
    width: 280,
    height: 280,
    borderRadius: borderRadius.xl,
    marginBottom: spacing.xl,
  },

  info: {
    alignItems: 'center',
    marginBottom: spacing.xxxl,
  },

  title: {
    fontSize: typography.fontSize['2xl'],
    fontWeight: typography.fontWeight.bold,
    color: colors.text.primary,
    marginBottom: spacing.xs,
    textAlign: 'center',
  },

  description: {
    fontSize: typography.fontSize.base,
    color: colors.text.secondary,
    textAlign: 'center',
  },

  progressContainer: {
    width: '100%',
    marginBottom: spacing.xxxl,
  },

  progressBar: {
    width: '100%',
    height: 4,
    backgroundColor: colors.neutral[200],
    borderRadius: 2,
    overflow: 'hidden',
    marginBottom: spacing.sm,
  },

  progressFill: {
    height: '100%',
    backgroundColor: colors.primary.main,
    borderRadius: 2,
  },

  timeLabels: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },

  timeText: {
    fontSize: typography.fontSize.xs,
    color: colors.text.tertiary,
  },

  controls: {
    alignItems: 'center',
  },

  playButton: {
    width: 72,
    height: 72,
    borderRadius: 36,
    backgroundColor: colors.primary.main,
    alignItems: 'center',
    justifyContent: 'center',
  },

  playButtonText: {
    fontSize: 32,
    color: colors.primary.contrast,
  },
});
