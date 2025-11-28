//
//  MediaPlayerScreen.swift
//  GreatFeelSwiftUI
//
//  Simple Spotify-style media player for audio/video content
//

import SwiftUI
import AVKit
import AVFoundation

// MARK: - Audio Player Manager
class AudioPlayerManager: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0

    private var player: AVAudioPlayer?
    private var timer: Timer?

    func loadAudio(named fileName: String, withExtension ext: String = "mp3") {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: ext) else {
            print("❌ Audio file not found: \(fileName).\(ext)")
            // Try playing default ocean sounds as fallback
            loadDefaultAudio()
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            duration = player?.duration ?? 0
            print("✅ Audio loaded: \(fileName).\(ext) - Duration: \(duration)s")
        } catch {
            print("❌ Error loading audio: \(error.localizedDescription)")
            loadDefaultAudio()
        }
    }

    func loadAudioFromURL(_ urlString: String?) {
        guard let urlString = urlString, let _ = URL(string: urlString) else {
            loadDefaultAudio()
            return
        }

        // For remote URLs, you'd use AVPlayer instead of AVAudioPlayer
        print("Loading from URL: \(urlString)")
        loadDefaultAudio()
    }

    private func loadDefaultAudio() {
        // Try to load sea-mp3 as default
        if let url = Bundle.main.url(forResource: "sea-mp3", withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.prepareToPlay()
                duration = player?.duration ?? 180
            } catch {
                duration = 180 // Default 3 minutes
            }
        } else {
            duration = 180 // Default 3 minutes
        }
    }

    func play() {
        player?.play()
        isPlaying = true
        startTimer()
    }

    func pause() {
        player?.pause()
        isPlaying = false
        stopTimer()
    }

    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }

    func seek(to time: Double) {
        player?.currentTime = time
        currentTime = time
    }

    func setVolume(_ volume: Float) {
        player?.volume = volume
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.currentTime = self.player?.currentTime ?? 0

            // Auto-stop when finished
            if self.currentTime >= self.duration {
                self.pause()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func cleanup() {
        stopTimer()
        player?.stop()
        player = nil
    }
}

// MARK: - Media Player Screen
struct MediaPlayerScreen: View {
    let session: MeditationSession
    let mood: Mood?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @StateObject private var meditationViewModel = MeditationViewModel()
    @State private var triggerTreeWind = false
    @StateObject private var audioPlayer = AudioPlayerManager()
    @State private var volume: Double = 0.7
    @State private var showSavedAnimation = false

    private var isSaved: Bool {
        meditationViewModel.isSaved(session.id)
    }

    var body: some View {
        ZStack {
            // Background Gradient based on mood
            LinearGradient(
                colors: mood?.gradientColors ?? (colorScheme == .dark
                    ? [AppColors.Dark.deepNightStart, AppColors.Dark.deepNightEnd]
                    : [Color(hex: "EEF2FF"), Color(hex: "E0E7FF")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Animated Tree Overlay (only in dark mode)
            if colorScheme == .dark {
                AnimatedTreeView(triggerWind: $triggerTreeWind)
                    .ignoresSafeArea()
            }

            VStack(spacing: 0) {
                // Top Bar with minimal Save button
                HStack {
                    Button(action: {
                        audioPlayer.cleanup()
                        dismiss()
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(8)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Circle())
                    }

                    Spacer()

                    // Minimal Save Button
                    Button(action: {
                        meditationViewModel.toggleSaveSession(session.id)
                        showSavedAnimation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showSavedAnimation = false
                        }
                    }) {
                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(8)
                            .background(isSaved ? Color.white.opacity(0.25) : Color.white.opacity(0.15))
                            .clipShape(Circle())
                            .scaleEffect(showSavedAnimation ? 1.15 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showSavedAnimation)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Spacer()

                // Album Art / Cover (Minimal)
                VStack(spacing: 24) {
                    AsyncImage(url: URL(string: session.coverImage ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .empty, .failure, _:
                            LinearGradient(
                                colors: mood?.gradientColors ?? [
                                    AppColors.primary(for: colorScheme),
                                    AppColors.secondary(for: colorScheme)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .overlay(
                                Image(systemName: categoryIcon(for: session.category))
                                    .font(.system(size: 60))
                                    .foregroundColor(.white.opacity(0.4))
                            )
                        }
                    }
                    .frame(width: 280, height: 280)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.2), radius: 15, y: 8)

                    // Song Info (Minimal)
                    VStack(spacing: 6) {
                        Text(session.title)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

                        if let instructor = session.instructor {
                            Text(instructor)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        } else {
                            Text(session.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer()

                // Progress Bar (Minimal)
                VStack(spacing: 6) {
                    // Slider
                    Slider(value: Binding(
                        get: { audioPlayer.currentTime },
                        set: { audioPlayer.seek(to: $0) }
                    ), in: 0...max(audioPlayer.duration, 1))
                        .tint(.white.opacity(0.9))

                    // Time Labels
                    HStack {
                        Text(formatTime(audioPlayer.currentTime))
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))

                        Spacer()

                        Text(formatTime(audioPlayer.duration))
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                .padding(.horizontal, 32)

                Spacer().frame(height: 24)

                // Playback Controls (Minimal)
                HStack(spacing: 50) {
                    // Previous
                    Button(action: {
                        audioPlayer.seek(to: 0)
                    }) {
                        Image(systemName: "backward.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.9))
                    }

                    // Play/Pause (Minimal)
                    Button(action: {
                        audioPlayer.togglePlayPause()
                        triggerTreeWind.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.95))
                                .frame(width: 56, height: 56)
                                .shadow(color: .black.opacity(0.15), radius: 8)

                            Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.black.opacity(0.85))
                        }
                    }

                    // Next
                    Button(action: {}) {
                        Image(systemName: "forward.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .padding(.vertical, 16)

                // Volume Control (Minimal)
                HStack(spacing: 10) {
                    Image(systemName: "speaker.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))

                    Slider(value: $volume, in: 0...1, onEditingChanged: { _ in
                        audioPlayer.setVolume(Float(volume))
                    })
                        .tint(.white.opacity(0.8))

                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.horizontal, 32)

                Spacer().frame(height: 32)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Load audio but DON'T auto-play
            // User must manually press play button
            if let audioUrl = session.audioUrl {
                audioPlayer.loadAudioFromURL(audioUrl)
            } else {
                // Load default sea-mp3 audio
                audioPlayer.loadAudio(named: "sea-mp3", withExtension: "mp3")
            }
            audioPlayer.setVolume(Float(volume))
            print("🎵 MediaPlayerScreen: Audio loaded, ready for manual playback")
        }
        .onDisappear {
            audioPlayer.cleanup()
        }
    }

    private func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%d:%02d", mins, secs)
    }

    private func categoryIcon(for category: MeditationCategory) -> String {
        switch category {
        case .natureSounds: return "leaf.fill"
        case .oceanWaves: return "water.waves"
        case .rainSounds: return "cloud.rain.fill"
        case .forestAmbience: return "tree.fill"
        case .guidedMeditation: return "figure.mind.and.body"
        case .sleepSounds: return "moon.stars.fill"
        case .mindfulness: return "sparkles"
        case .breathingExercises: return "wind"
        case .chakraMeditation: return "circle.hexagongrid.fill"
        case .whiteNoise: return "waveform"
        case .thunderstorm: return "cloud.bolt.rain.fill"
        case .mountainZen: return "mountain.2.fill"
        }
    }
}

// MARK: - Preview
#Preview {
    MediaPlayerScreen(session: MeditationSession.mockSessions[0], mood: .cozy)
}
