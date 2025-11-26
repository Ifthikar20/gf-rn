import React, { useState, useEffect, useRef } from 'react';
import { View, Text, StyleSheet, SafeAreaView, Image, TouchableOpacity, Alert } from 'react-native';
import Sound from 'react-native-sound';
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
        audioUrl: any;
      };
    };
  };
  navigation: any;
}

export const AudioPlayerScreen: React.FC<AudioPlayerScreenProps> = ({ route, navigation }) => {
  const colors = useThemedColors();
  const { category } = route.params;
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [totalTime, setTotalTime] = useState(0);
  const [isLoading, setIsLoading] = useState(true);
  const soundRef = useRef<Sound | null>(null);
  const progressInterval = useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    // Enable playback in silence mode (iOS)
    Sound.setCategory('Playback');

    // Load the audio file
    loadAudio();

    // Cleanup on unmount
    return () => {
      if (soundRef.current) {
        soundRef.current.stop();
        soundRef.current.release();
      }
      if (progressInterval.current) {
        clearInterval(progressInterval.current);
      }
    };
  }, []);

  const loadAudio = () => {
    try {
      const sound = new Sound(category.audioUrl, Sound.MAIN_BUNDLE, (error) => {
        if (error) {
          console.error('Failed to load the sound', error);
          Alert.alert('Error', 'Failed to load audio file');
          setIsLoading(false);
          return;
        }

        // Successfully loaded
        soundRef.current = sound;
        setTotalTime(Math.floor(sound.getDuration()));
        setIsLoading(false);
      });
    } catch (error) {
      console.error('Error creating sound:', error);
      Alert.alert('Error', 'Failed to initialize audio');
      setIsLoading(false);
    }
  };

  const handlePlayPause = () => {
    if (!soundRef.current || isLoading) return;

    if (isPlaying) {
      // Pause
      soundRef.current.pause();
      setIsPlaying(false);
      if (progressInterval.current) {
        clearInterval(progressInterval.current);
      }
    } else {
      // Play
      soundRef.current.play((success) => {
        if (success) {
          console.log('Successfully finished playing');
        } else {
          console.log('Playback failed due to audio decoding errors');
        }
        setIsPlaying(false);
        if (progressInterval.current) {
          clearInterval(progressInterval.current);
        }
      });
      setIsPlaying(true);

      // Start updating progress
      progressInterval.current = setInterval(() => {
        if (soundRef.current) {
          soundRef.current.getCurrentTime((seconds) => {
            setCurrentTime(Math.floor(seconds));
          });
        }
      }, 100);
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
              <TouchableOpacity
                style={[
                  styles.playButton,
                  { backgroundColor: colors.primary.main },
                  isLoading && { opacity: 0.5 }
                ]}
                onPress={handlePlayPause}
                disabled={isLoading}
              >
                <Text style={[styles.playButtonText, { color: colors.primary.contrast }]}>
                  {isLoading ? '...' : isPlaying ? '❚❚' : '▶'}
                </Text>
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
