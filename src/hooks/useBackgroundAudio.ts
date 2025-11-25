import { useEffect, useState } from 'react';

// Gracefully handle expo-av module if not available
let Audio: any = null;
try {
  const expoAV = require('expo-av');
  Audio = expoAV.Audio;
} catch (error) {
  console.log('expo-av not available - background audio disabled. Run "cd ios && pod install" to enable.');
}

export const useBackgroundAudio = () => {
  const [sound, setSound] = useState<any>(null);
  const [isPlaying, setIsPlaying] = useState(false);

  useEffect(() => {
    // If Audio module is not available, skip setup
    if (!Audio) {
      return;
    }

    let isMounted = true;

    const setupAudio = async () => {
      try {
        // Configure audio mode for background playback
        await Audio.setAudioModeAsync({
          playsInSilentModeIOS: true,
          staysActiveInBackground: true,
          shouldDuckAndroid: true,
        });

        // Load rain sounds audio - using a royalty-free rain sound URL
        const { sound: audioSound } = await Audio.Sound.createAsync(
          // Using a sample rain sound - replace with your actual audio file
          { uri: 'https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3' },
          { shouldPlay: true, isLooping: true, volume: 0.3 }
        );

        if (isMounted) {
          setSound(audioSound);
          setIsPlaying(true);
        }
      } catch (error) {
        console.log('Error setting up background audio:', error);
      }
    };

    setupAudio();

    // Cleanup function
    return () => {
      isMounted = false;
      if (sound) {
        sound.unloadAsync();
      }
    };
  }, []);

  const togglePlayback = async () => {
    if (!sound || !Audio) return;

    try {
      const status = await sound.getStatusAsync();
      if (status.isLoaded) {
        if (isPlaying) {
          await sound.pauseAsync();
          setIsPlaying(false);
        } else {
          await sound.playAsync();
          setIsPlaying(true);
        }
      }
    } catch (error) {
      console.log('Error toggling playback:', error);
    }
  };

  const setVolume = async (volume: number) => {
    if (!sound || !Audio) return;
    try {
      await sound.setVolumeAsync(volume);
    } catch (error) {
      console.log('Error setting volume:', error);
    }
  };

  return { isPlaying, togglePlayback, setVolume };
};
