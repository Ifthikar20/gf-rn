//
//  VideoPlayerScreen.swift
//  GreatFeelSwiftUI
//
//  Modern video player screen with blur transition and episode carousel
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
    @State private var isFullscreen = false
    @State private var bookmarkPulse = false

    // Get screen dimensions
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    private var videoHeight: CGFloat {
        screenHeight * 0.5 // 50% of screen height
    }

    var body: some View {
        ZStack {
            if isFullscreen {
                fullscreenView
            } else {
                portraitView
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

    // MARK: - Portrait View
    private var portraitView: some View {
        ZStack {
            // Pure black background (forced dark mode)
            Color.black
                .ignoresSafeArea()

            // Scrollable content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Video Player Section (50% screen height)
                    videoPlayerSection

                    // Blur Transition (-40px overlap)
                    blurTransition
                        .offset(y: -40)

                    // Content Section
                    contentSection
                        .offset(y: -40)

                    // Related Episodes Section
                    relatedEpisodesSection
                        .offset(y: -40)

                    // Bottom spacing for safe area
                    Spacer()
                        .frame(height: 100)
                }
            }
            .ignoresSafeArea(edges: .top)

            // Floating Header Overlay
            VStack {
                floatingHeader
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
        }
    }

    // MARK: - Video Player Section
    private var videoPlayerSection: some View {
        ZStack(alignment: .topTrailing) {
            if let player = player {
                VideoPlayer(player: player)
                    .frame(height: videoHeight)
                    .background(Color.black)
            } else {
                // Loading placeholder
                Rectangle()
                    .fill(Color.black)
                    .frame(height: videoHeight)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    )
            }

            // Fullscreen expand button
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isFullscreen = true
                }
            }) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(.top, 60)
            .padding(.trailing, 16)
        }
    }

    // MARK: - Blur Transition
    private var blurTransition: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    stops: [
                        .init(color: Color.black.opacity(0), location: 0),
                        .init(color: Color.black.opacity(0.3), location: 0.3),
                        .init(color: Color.black.opacity(0.6), location: 0.6),
                        .init(color: Color.black, location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .blur(radius: 20)
            .frame(height: 80)
    }

    // MARK: - Floating Header
    private var floatingHeader: some View {
        HStack {
            // Back button
            Button(action: {
                player?.pause()
                dismiss()
            }) {
                Image(systemName: "chevron.down")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }

            Spacer()

            // Bookmark button
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isSaved.toggle()
                    bookmarkPulse = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    bookmarkPulse = false
                }
            }) {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSaved ? Color.yellow : .white)
                    .frame(width: 44, height: 44)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
                    .scaleEffect(bookmarkPulse ? 1.2 : 1.0)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 50)
    }

    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title (32pt bold, 100% white)
            Text(session.title)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(2)

            // Meta information row
            HStack(spacing: 12) {
                // Category chip
                categoryChip

                // Duration
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text("\(session.duration) min")
                        .font(.system(size: 14))
                }
                .foregroundColor(.white.opacity(0.6))

                // Bookmark indicator (if saved)
                if isSaved {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color.yellow.opacity(0.8))
                }
            }

            // Instructor section
            if let instructor = session.instructor {
                instructorSection(name: instructor)
            }

            // About section
            VStack(alignment: .leading, spacing: 8) {
                Text("About")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)

                if let description = session.description {
                    Text(description)
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.75))
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            // Video session badge
            HStack(spacing: 6) {
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 12))
                Text("VIDEO SESSION")
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(0.5)
            }
            .foregroundColor(.white.opacity(0.5))
            .padding(.top, 8)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }

    // MARK: - Category Chip
    private var categoryChip: some View {
        HStack(spacing: 6) {
            Image(systemName: session.category.icon)
                .font(.system(size: 12))
            Text(session.category.rawValue)
                .font(.system(size: 14, weight: .medium))
        }
        .foregroundColor(.white.opacity(0.9))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.15))
        .clipShape(Capsule())
    }

    // MARK: - Instructor Section
    private func instructorSection(name: String) -> some View {
        HStack(spacing: 12) {
            // Avatar with initial
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)

                Text(String(name.prefix(1)))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))

                Text("Meditation Instructor")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()
        }
    }

    // MARK: - Related Episodes Section
    private var relatedEpisodesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("More Episodes")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(getRelatedEpisodes()) { episode in
                        EpisodeCard(session: episode)
                            .onTapGesture {
                                // Switch to new episode
                                switchToEpisode(episode)
                            }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.top, 32)
    }

    // MARK: - Fullscreen View
    private var fullscreenView: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
            }

            // Fullscreen controls overlay
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isFullscreen = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text(session.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Spacer()

                    Button(action: {
                        // Info action
                    }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 50)

                Spacer()
            }
        }
    }

    // MARK: - Helper Methods
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

    private func getRelatedEpisodes() -> [MeditationSession] {
        // Get other video sessions, excluding current one
        MeditationSession.mockSessions
            .filter { $0.contentType == .video && $0.id != session.id }
    }

    private func switchToEpisode(_ episode: MeditationSession) {
        // Pause current player
        player?.pause()
        player = nil

        // Setup new episode
        guard let videoUrlString = episode.videoUrl,
              let url = URL(string: videoUrlString) else {
            return
        }

        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true
    }
}

// MARK: - Episode Card Component
struct EpisodeCard: View {
    let session: MeditationSession

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Thumbnail with play overlay
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 280, height: 160)
                    .cornerRadius(16)

                // Play icon overlay
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.white.opacity(0.9))
            }
            .appShadow(AppSpacing.Shadow.medium)

            // Episode info
            VStack(alignment: .leading, spacing: 6) {
                Text(session.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .frame(width: 280, alignment: .leading)

                HStack(spacing: 6) {
                    Image(systemName: session.category.icon)
                        .font(.system(size: 12))
                    Text(session.category.rawValue)
                        .font(.system(size: 14))
                }
                .foregroundColor(.white.opacity(0.6))
            }
        }
        .frame(width: 280)
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
