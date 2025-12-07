//
//  AnimatedWelcomeCharacter.swift
//  GreatFeelSwiftUI
//
//  Created by Claude Code
//

import SwiftUI
import AVKit

struct AnimatedWelcomeCharacter: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var player: AVPlayer?

    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .frame(width: 200, height: 200)
                    .cornerRadius(16)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .disabled(true) // Disable interaction with video controls
            } else {
                // Fallback while loading
                VStack(spacing: 12) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            print("AnimatedWelcomeCharacter appeared - loading video...")
            setupVideoPlayer()

            // Zoom in animation
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
        .onDisappear {
            // Clean up player
            player?.pause()
            player = nil
        }
    }

    private func setupVideoPlayer() {
        // Try to find the welcome video in the bundle
        // First try "video-iamge.mp4", then fall back to "night-sky.mp4"
        var videoURL: URL?

        if let url = Bundle.main.url(forResource: "video-iamge", withExtension: "mp4") {
            videoURL = url
            print("Found video-iamge.mp4")
        } else if let url = Bundle.main.url(forResource: "night-sky", withExtension: "mp4") {
            videoURL = url
            print("Using fallback video: night-sky.mp4")
        } else {
            print("No video file found in bundle")
            return
        }

        guard let url = videoURL else { return }

        let playerItem = AVPlayerItem(url: url)
        let videoPlayer = AVPlayer(playerItem: playerItem)

        // Configure for autoplay and looping
        videoPlayer.isMuted = true // Mute by default for autoplay

        // Add observer for looping
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            videoPlayer.seek(to: .zero)
            videoPlayer.play()
        }

        self.player = videoPlayer

        // Start playing
        videoPlayer.play()
        print("Video player started")
    }
}

// Alternative version without controls for cleaner look
struct WelcomeVideoPlayer: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var player: AVPlayer?

    var body: some View {
        ZStack {
            if let player = player {
                // Custom video player without controls
                VideoPlayerView(player: player)
                    .frame(width: 200, height: 200)
                    .cornerRadius(16)
                    .scaleEffect(scale)
                    .opacity(opacity)
            } else {
                // Fallback
                VStack(spacing: 12) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            print("WelcomeVideoPlayer appeared - loading video...")
            setupVideoPlayer()

            // Zoom in animation
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }

    private func setupVideoPlayer() {
        var videoURL: URL?

        if let url = Bundle.main.url(forResource: "video-iamge", withExtension: "mp4") {
            videoURL = url
            print("Found video-iamge.mp4")
        } else if let url = Bundle.main.url(forResource: "night-sky", withExtension: "mp4") {
            videoURL = url
            print("Using fallback video: night-sky.mp4")
        }

        guard let url = videoURL else {
            print("No video file found")
            return
        }

        let playerItem = AVPlayerItem(url: url)
        let videoPlayer = AVPlayer(playerItem: playerItem)
        videoPlayer.isMuted = true

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            videoPlayer.seek(to: .zero)
            videoPlayer.play()
        }

        self.player = videoPlayer
        videoPlayer.play()
        print("Video player started")
    }
}

// UIKit wrapper for cleaner video playback without controls
struct VideoPlayerView: UIViewRepresentable {
    let player: AVPlayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)

        context.coordinator.playerLayer = playerLayer

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerLayer = context.coordinator.playerLayer {
            playerLayer.frame = uiView.bounds
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        var playerLayer: AVPlayerLayer?
    }
}

#Preview {
    ZStack {
        Color.white
        AnimatedWelcomeCharacter()
    }
}
