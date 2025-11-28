//
//  VideoPlayerScreen.swift
//  GreatFeelSwiftUI
//
//  Video player screen with expand functionality
//

import SwiftUI
import AVKit

struct VideoPlayerScreen: View {
    let session: MeditationSession
    let mood: Mood?
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeViewModel: ThemeViewModel

    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var isSaved = false
    @State private var showFullScreen = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: mood?.gradientColors ?? [Color(hex: "1E1B4B"), Color(hex: "312E81")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        player?.pause()
                        dismiss()
                    }) {
                        Image(systemName: "chevron.down")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    // Save button (minimal design)
                    Button(action: {
                        isSaved.toggle()
                    }) {
                        Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(isSaved ? Color.white.opacity(0.25) : Color.white.opacity(0.15))
                            .clipShape(Circle())
                    }
                }
                .padding()

                Spacer().frame(height: 20)

                // Video Player
                if let player = player {
                    ZStack(alignment: .topTrailing) {
                        VideoPlayer(player: player)
                            .frame(height: showFullScreen ? UIScreen.main.bounds.height - 100 : 250)
                            .cornerRadius(16)
                            .padding(.horizontal)

                        // Expand button
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showFullScreen.toggle()
                            }
                        }) {
                            Image(systemName: showFullScreen ? "arrow.down.right.and.arrow.up.left" : "arrow.up.left.and.arrow.down.right")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .padding(30)
                    }
                } else {
                    // Placeholder
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: showFullScreen ? UIScreen.main.bounds.height - 100 : 250)
                        .cornerRadius(16)
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        )
                        .padding(.horizontal)
                }

                if !showFullScreen {
                    Spacer().frame(height: 30)

                    // Content Section
                    VStack(alignment: .leading, spacing: 16) {
                        // Title
                        Text(session.title)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)

                        // Category and Duration
                        HStack(spacing: 12) {
                            HStack(spacing: 6) {
                                Image(systemName: session.category.icon)
                                    .font(.caption)
                                Text(session.category.rawValue)
                                    .font(.subheadline)
                            }
                            .foregroundColor(.white.opacity(0.7))

                            Circle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 4, height: 4)

                            Text("\(session.duration) min")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))

                            if let instructor = session.instructor {
                                Circle()
                                    .fill(Color.white.opacity(0.5))
                                    .frame(width: 4, height: 4)

                                Text(instructor)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }

                        // Description
                        if let description = session.description {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .lineLimit(3)
                                .padding(.top, 8)
                        }

                        // Type indicator
                        HStack(spacing: 4) {
                            Image(systemName: "play.rectangle.fill")
                                .font(.caption2)
                            Text(session.contentType.displayLabel.uppercased())
                                .font(.caption2)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 24)

                    Spacer()
                }
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }

    private func setupPlayer() {
        guard let videoUrlString = session.videoUrl,
              let url = URL(string: videoUrlString) else {
            print("❌ Invalid video URL")
            return
        }

        print("🎥 Setting up video player for: \(session.title)")
        print("🎥 Video URL: \(videoUrlString)")

        player = AVPlayer(url: url)

        // Auto-play
        player?.play()
        isPlaying = true

        // Observe playback status
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { _ in
            print("✅ Video finished playing")
            player?.seek(to: .zero)
            isPlaying = false
        }
    }
}

// MARK: - Preview
#Preview {
    VideoPlayerScreen(
        session: MeditationSession.mockSessions.first(where: { $0.contentType == .video })!,
        mood: .calm
    )
    .environmentObject(ThemeViewModel())
}
