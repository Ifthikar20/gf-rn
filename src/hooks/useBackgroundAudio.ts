import { useEffect, useRef } from 'react';
import { useTheme } from '@/contexts/ThemeContext';
import { Audio } from 'expo-av';

export const useBackgroundAudio = () => {
  const { getMoodConfig, isMuted, mood } = useTheme();
  const soundRef = useRef<Audio.Sound | null>(null);

  useEffect(() => {
    let isMounted = true;

    const playAudio = async () => {
      try {
        // Stop and unload previous sound if it exists
        if (soundRef.current) {
          await soundRef.current.stopAsync();
          await soundRef.current.unloadAsync();
          soundRef.current = null;
        }

        if (isMuted) return;

        const moodConfig = getMoodConfig();

        // Create and load new sound
        const { sound } = await Audio.Sound.createAsync(
          { uri: moodConfig.audioUrl },
          { shouldPlay: true, isLooping: true, volume: 0.3 }
        );

        if (isMounted) {
          soundRef.current = sound;
        }
      } catch (error) {
        console.error('Error playing background audio:', error);
      }
    };

    playAudio();

    return () => {
      isMounted = false;
      if (soundRef.current) {
        soundRef.current.stopAsync();
        soundRef.current.unloadAsync();
        soundRef.current = null;
      }
    };
  }, [mood, isMuted]);

  useEffect(() => {
    const updateVolume = async () => {
      if (soundRef.current) {
        if (isMuted) {
          await soundRef.current.stopAsync();
        } else {
          try {
            await soundRef.current.playAsync();
          } catch (error) {
            console.error('Error resuming audio:', error);
          }
        }
      }
    };

    updateVolume();
  }, [isMuted]);

  return null;
};
