import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, SafeAreaView, Image, TouchableOpacity } from 'react-native';
import { Audio } from 'expo-av';
import { ThemedBackground } from '@components/common';
import { spacing, typography, borderRadius } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';

interface AudioPlayerScreenProps {
  route: {
    params: {
      category: {
        id: string;
        title: string;
        description: string;
        image: any;
        audioUrl: any; // Can be URL string or require() for local audio
      };
    };
  };
  navigation: any;
}

export const AudioPlayerScreen: React.FC<AudioPlayerScreenProps> = ({ route, navigation }) => {
  const colors = useThemedColors();
  const { category } = route.params;
  const [sound, setSound] = useState<Audio.Sound | null>(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [totalTime, setTotalTime] = useState(0);

  useEffect(() => {
    // Load audio when component mounts
    loadAudio();

    // Cleanup when component unmounts
    return () => {
      if (sound) {
        sound.unloadAsync();
      }
    };
  }, []);

  const loadAudio = async () => {
    try {
      await Audio.setAudioModeAsync({
        allowsRecordingIOS: false,
        playsInSilentModeIOS: true,
        staysActiveInBackground: true,
      });

      const { sound: newSound } = await Audio.Sound.createAsync(
        category.audioUrl,
        { shouldPlay: false },
        onPlaybackStatusUpdate
      );

      setSound(newSound);
    } catch (error) {
      console.error('Error loading audio:', error);
    }
  };

  const onPlaybackStatusUpdate = (status: any) => {
    if (status.isLoaded) {
      setCurrentTime(Math.floor(status.positionMillis / 1000));
      setTotalTime(Math.floor(status.durationMillis / 1000));
      setIsPlaying(status.isPlaying);
    }
  };

  const handlePlayPause = async () => {
    if (!sound) return;

    try {
      if (isPlaying) {
        await sound.pauseAsync();
      } else {
        await sound.playAsync();
      }
    } catch (error) {
      console.error('Error toggling playback:', error);
    }
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const progress = totalTime > 0 ? (currentTime / totalTime) * 100 : 0;

  return (
    <ThemedBackground>
      <SafeAreaView style={styles.safeArea}>
        <View style={styles.container}>
          <TouchableOpacity style={styles.backButton} onPress={() => navigation.goBack()}>
            <Text style={[styles.backText, { color: colors.primary.main }]}>← Back</Text>
          </TouchableOpacity>

          <View style={styles.content}>
            <Image source={category.image} style={styles.coverImage} />

            <View style={styles.info}>
              <Text style={[styles.title, { color: colors.text.primary }]}>{category.title}</Text>
              <Text style={[styles.description, { color: colors.text.secondary }]}>{category.description}</Text>
            </View>

            <View style={styles.progressContainer}>
              <View style={[styles.progressBar, { backgroundColor: colors.neutral[200] }]}>
                <View style={[styles.progressFill, { width: `${progress}%`, backgroundColor: colors.primary.main }]} />
              </View>
              <View style={styles.timeLabels}>
                <Text style={[styles.timeText, { color: colors.text.tertiary }]}>{formatTime(currentTime)}</Text>
                <Text style={[styles.timeText, { color: colors.text.tertiary }]}>{formatTime(totalTime)}</Text>
              </View>
            </View>

            <View style={styles.controls}>
              <TouchableOpacity style={[styles.playButton, { backgroundColor: colors.primary.main }]} onPress={handlePlayPause}>
                <Text style={[styles.playButtonText, { color: colors.primary.contrast }]}>{isPlaying ? '❚❚' : '▶'}</Text>
              </TouchableOpacity>
            </View>
          </View>
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

  backButton: {
    padding: spacing.md,
    paddingLeft: spacing.screenPadding,
  },

  backText: {
    fontSize: typography.fontSize.base,
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
    marginBottom: spacing.xs,
    textAlign: 'center',
  },

  description: {
    fontSize: typography.fontSize.base,
    textAlign: 'center',
  },

  progressContainer: {
    width: '100%',
    marginBottom: spacing.xxxl,
  },

  progressBar: {
    width: '100%',
    height: 4,
    borderRadius: 2,
    overflow: 'hidden',
    marginBottom: spacing.sm,
  },

  progressFill: {
    height: '100%',
    borderRadius: 2,
  },

  timeLabels: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },

  timeText: {
    fontSize: typography.fontSize.xs,
  },

  controls: {
    alignItems: 'center',
  },

  playButton: {
    width: 72,
    height: 72,
    borderRadius: 36,
    alignItems: 'center',
    justifyContent: 'center',
  },

  playButtonText: {
    fontSize: 32,
  },
});
