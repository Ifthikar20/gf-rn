//
//  VideoPlayerScreen.swift
//  GreatFeelSwiftUI
//
//  Modern video player screen with blur transition and episode carousel
//

import SwiftUI
import AVKit
import Combine

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
    @State private var isLoadingVideo = true
    @State private var loadingError: String?

    // Get screen dimensions
    private var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    private var videoHeight: CGFloat {
        screenHeight * 0.5 // 50% of screen height
    }

    // Logging helper
    private func log(_ message: String, type: String = "INFO") {
        let emoji = type == "ERROR" ? "❌" : type == "SUCCESS" ? "✅" : type == "WARNING" ? "⚠️" : "ℹ️"
        print("[\(emoji) VideoPlayer] \(message)")
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
            if let error = loadingError {
                // Error state
                Rectangle()
                    .fill(Color.black)
                    .frame(height: videoHeight)
                    .overlay(
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundColor(.red)

                            Text("Failed to load video")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)

                            Text(error)
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)

                            Button(action: {
                                loadingError = nil
                                isLoadingVideo = true
                                setupPlayer()
                            }) {
                                Text("Retry")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                        }
                    )
            } else if let player = player, !isLoadingVideo {
                VideoPlayer(player: player)
                    .frame(height: videoHeight)
                    .background(Color.black)
            } else {
                // Loading placeholder
                Rectangle()
                    .fill(Color.black)
                    .frame(height: videoHeight)
                    .overlay(
                        VStack(spacing: 16) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)

                            Text("Loading video...")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.8))
                        }
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
        log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        log("Starting video player setup")
        log("Session: \(session.title)")
        log("Session ID: \(session.id)")
        log("Content Type: \(session.contentType.rawValue)")

        guard let videoUrlString = session.videoUrl else {
            log("Video URL is nil for session: \(session.title)", type: "ERROR")
            loadingError = "No video URL available"
            isLoadingVideo = false
            return
        }

        guard let url = URL(string: videoUrlString) else {
            log("Invalid video URL: \(videoUrlString)", type: "ERROR")
            loadingError = "Invalid video URL format"
            isLoadingVideo = false
            return
        }

        log("Video URL: \(videoUrlString)")
        log("Creating AVAsset for async loading...")

        // Create AVAsset and load properties asynchronously
        let asset = AVAsset(url: url)

        // Load asset properties asynchronously to avoid blocking main thread
        Task {
            do {
                log("Loading asset properties asynchronously...")

                // Load required properties
                let (isPlayable, duration) = try await asset.load(.isPlayable, .duration)

                log("Asset properties loaded successfully", type: "SUCCESS")
                log("  - Is Playable: \(isPlayable)")
                log("  - Duration: \(duration.seconds) seconds")

                if !isPlayable {
                    log("Asset is not playable", type: "ERROR")
                    await MainActor.run {
                        loadingError = "Video format not supported"
                        isLoadingVideo = false
                    }
                    return
                }

                // Create player item and player on main thread
                await MainActor.run {
                    log("Creating AVPlayerItem and AVPlayer...")
                    let playerItem = AVPlayerItem(asset: asset)

                    // Observe player item status
                    addPlayerItemObserver(playerItem)

                    player = AVPlayer(playerItem: playerItem)

                    log("Player created successfully", type: "SUCCESS")
                    log("Starting playback...")

                    // Auto-play
                    player?.play()
                    isPlaying = true
                    isLoadingVideo = false

                    log("Playback started", type: "SUCCESS")

                    // Observe playback completion
                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: playerItem,
                        queue: .main
                    ) { [weak self] _ in
                        self?.log("Video playback completed", type: "SUCCESS")
                        self?.player?.seek(to: .zero)
                        self?.isPlaying = false
                    }

                    // Observe playback errors
                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemFailedToPlayToEndTime,
                        object: playerItem,
                        queue: .main
                    ) { [weak self] notification in
                        if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error {
                            self?.log("Playback failed: \(error.localizedDescription)", type: "ERROR")
                            self?.loadingError = error.localizedDescription
                            self?.isLoadingVideo = false
                        }
                    }
                }

                log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

            } catch {
                log("Failed to load asset properties: \(error.localizedDescription)", type: "ERROR")
                log("Error details: \(error)", type: "ERROR")

                await MainActor.run {
                    loadingError = "Failed to load video: \(error.localizedDescription)"
                    isLoadingVideo = false
                }

                log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            }
        }
    }

    private func addPlayerItemObserver(_ playerItem: AVPlayerItem) {
        log("Adding player item status observer...")

        // Observe status changes
        playerItem.publisher(for: \.status)
            .sink { [weak self] status in
                self?.log("Player item status changed: \(status.rawValue)")

                switch status {
                case .readyToPlay:
                    self?.log("Player item ready to play", type: "SUCCESS")
                case .failed:
                    if let error = playerItem.error {
                        self?.log("Player item failed: \(error.localizedDescription)", type: "ERROR")
                        self?.loadingError = error.localizedDescription
                        self?.isLoadingVideo = false
                    }
                case .unknown:
                    self?.log("Player item status unknown", type: "WARNING")
                @unknown default:
                    self?.log("Player item unknown status: \(status.rawValue)", type: "WARNING")
                }
            }
            .store(in: &observers)
    }

    @State private var observers: Set<AnyCancellable> = []

    private func getRelatedEpisodes() -> [MeditationSession] {
        // Get other video sessions, excluding current one
        MeditationSession.mockSessions
            .filter { $0.contentType == .video && $0.id != session.id }
    }

    private func switchToEpisode(_ episode: MeditationSession) {
        log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        log("Switching to new episode: \(episode.title)")

        // Reset state
        isLoadingVideo = true
        loadingError = nil

        // Pause and cleanup current player
        log("Cleaning up current player...")
        player?.pause()
        player = nil
        observers.removeAll()

        log("Setting up new episode...")

        guard let videoUrlString = episode.videoUrl else {
            log("Video URL is nil for episode: \(episode.title)", type: "ERROR")
            loadingError = "No video URL available"
            isLoadingVideo = false
            return
        }

        guard let url = URL(string: videoUrlString) else {
            log("Invalid video URL: \(videoUrlString)", type: "ERROR")
            loadingError = "Invalid video URL format"
            isLoadingVideo = false
            return
        }

        log("Video URL: \(videoUrlString)")
        log("Creating AVAsset for async loading...")

        // Create AVAsset and load properties asynchronously
        let asset = AVAsset(url: url)

        Task {
            do {
                log("Loading asset properties asynchronously...")

                let (isPlayable, duration) = try await asset.load(.isPlayable, .duration)

                log("Asset properties loaded", type: "SUCCESS")
                log("  - Is Playable: \(isPlayable)")
                log("  - Duration: \(duration.seconds) seconds")

                if !isPlayable {
                    log("Asset is not playable", type: "ERROR")
                    await MainActor.run {
                        loadingError = "Video format not supported"
                        isLoadingVideo = false
                    }
                    return
                }

                await MainActor.run {
                    log("Creating player for new episode...")
                    let playerItem = AVPlayerItem(asset: asset)
                    addPlayerItemObserver(playerItem)

                    player = AVPlayer(playerItem: playerItem)
                    player?.play()
                    isPlaying = true
                    isLoadingVideo = false

                    log("New episode playback started", type: "SUCCESS")

                    NotificationCenter.default.addObserver(
                        forName: .AVPlayerItemDidPlayToEndTime,
                        object: playerItem,
                        queue: .main
                    ) { [weak self] _ in
                        self?.log("Episode playback completed", type: "SUCCESS")
                        self?.player?.seek(to: .zero)
                        self?.isPlaying = false
                    }
                }

                log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

            } catch {
                log("Failed to load asset: \(error.localizedDescription)", type: "ERROR")

                await MainActor.run {
                    loadingError = "Failed to load video: \(error.localizedDescription)"
                    isLoadingVideo = false
                }

                log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
            }
        }
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
