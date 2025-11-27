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
        guard let urlString = urlString, let url = URL(string: urlString) else {
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
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var triggerTreeWind = false
    @StateObject private var audioPlayer = AudioPlayerManager()
    @State private var volume: Double = 0.7

    var body: some View {
        ZStack {
            // Background Gradient (matching other screens)
            LinearGradient(
                colors: colorScheme == .dark
                    ? [AppColors.Dark.deepNightStart, AppColors.Dark.deepNightEnd]
                    : [Color(hex: "EEF2FF"), Color(hex: "E0E7FF")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Animated Tree Overlay (only in dark mode)
            if colorScheme == .dark {
                AnimatedTreeView(triggerWind: $triggerTreeWind)
                    .ignoresSafeArea()
            }

            VStack(spacing: 0) {
                // Top Bar
                HStack {
                    Button(action: {
                        audioPlayer.cleanup()
                        dismiss()
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.title3)
                            .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                            .padding(12)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.title3)
                            .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                            .padding(12)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                Spacer()

                // Album Art / Cover
                VStack(spacing: 30) {
                    AsyncImage(url: URL(string: session.coverImage ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .empty, .failure, _:
                            LinearGradient(
                                colors: [
                                    AppColors.primary(for: colorScheme),
                                    AppColors.secondary(for: colorScheme)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .overlay(
                                Image(systemName: categoryIcon(for: session.category))
                                    .font(.system(size: 80))
                                    .foregroundColor(.white.opacity(0.3))
                            )
                        }
                    }
                    .frame(width: 300, height: 300)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.3), radius: 20, y: 10)

                    // Song Info
                    VStack(spacing: 8) {
                        Text(session.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                            .multilineTextAlignment(.center)

                        if let instructor = session.instructor {
                            Text(instructor)
                                .font(.body)
                                .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                        } else {
                            Text(session.category.rawValue)
                                .font(.body)
                                .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Spacer()

                // Progress Bar
                VStack(spacing: 8) {
                    // Slider
                    Slider(value: Binding(
                        get: { audioPlayer.currentTime },
                        set: { audioPlayer.seek(to: $0) }
                    ), in: 0...max(audioPlayer.duration, 1))
                        .tint(AppColors.primary(for: colorScheme))

                    // Time Labels
                    HStack {
                        Text(formatTime(audioPlayer.currentTime))
                            .font(.caption)
                            .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)

                        Spacer()

                        Text(formatTime(audioPlayer.duration))
                            .font(.caption)
                            .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                    }
                }
                .padding(.horizontal, 30)

                Spacer().frame(height: 20)

                // Playback Controls
                HStack(spacing: 40) {
                    // Shuffle
                    Button(action: {}) {
                        Image(systemName: "shuffle")
                            .font(.title3)
                            .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                    }

                    // Previous
                    Button(action: {
                        audioPlayer.seek(to: 0)
                    }) {
                        Image(systemName: "backward.fill")
                            .font(.title)
                            .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                    }

                    // Play/Pause
                    Button(action: {
                        audioPlayer.togglePlayPause()
                        triggerTreeWind.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                                .shadow(color: .black.opacity(0.2), radius: 10)

                            Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }

                    // Next
                    Button(action: {}) {
                        Image(systemName: "forward.fill")
                            .font(.title)
                            .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                    }

                    // Repeat
                    Button(action: {}) {
                        Image(systemName: "repeat")
                            .font(.title3)
                            .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                    }
                }
                .padding(.vertical, 20)

                // Volume Control
                HStack(spacing: 12) {
                    Image(systemName: "speaker.fill")
                        .font(.caption)
                        .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)

                    Slider(value: $volume, in: 0...1, onEditingChanged: { _ in
                        audioPlayer.setVolume(Float(volume))
                    })
                        .tint(AppColors.primary(for: colorScheme))

                    Image(systemName: "speaker.wave.3.fill")
                        .font(.caption)
                        .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                }
                .padding(.horizontal, 30)

                Spacer().frame(height: 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Try to load audio from session URL or use default
            if let audioUrl = session.audioUrl {
                audioPlayer.loadAudioFromURL(audioUrl)
            } else {
                // Load default sea-mp3 audio
                audioPlayer.loadAudio(named: "sea-mp3", withExtension: "mp3")
            }
            audioPlayer.setVolume(Float(volume))
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
    MediaPlayerScreen(session: MeditationSession.mockSessions[0])
}
