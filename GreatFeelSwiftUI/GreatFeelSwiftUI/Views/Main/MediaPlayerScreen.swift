//
//  MediaPlayerScreen.swift
//  GreatFeelSwiftUI
//
//  Simple Spotify-style media player for audio/video content
//

import SwiftUI
import AVKit

struct MediaPlayerScreen: View {
    let session: MeditationSession
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var triggerTreeWind = false

    @State private var isPlaying = false
    @State private var currentTime: Double = 0
    @State private var duration: Double = 180 // Default 3 minutes
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
                    Button(action: { dismiss() }) {
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
                }

                Spacer()

                // Progress Bar
                VStack(spacing: 8) {
                    // Slider
                    Slider(value: $currentTime, in: 0...duration)
                        .tint(AppColors.primary(for: colorScheme))

                    // Time Labels
                    HStack {
                        Text(formatTime(currentTime))
                            .font(.caption)
                            .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)

                        Spacer()

                        Text(formatTime(duration))
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
                    Button(action: {}) {
                        Image(systemName: "backward.fill")
                            .font(.title)
                            .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                    }

                    // Play/Pause
                    Button(action: {
                        isPlaying.toggle()
                        triggerTreeWind.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                                .shadow(color: .black.opacity(0.2), radius: 10)

                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
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

                    Slider(value: $volume, in: 0...1)
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
            duration = Double(session.duration * 60) // Convert minutes to seconds
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
