//
//  AudioPlayerService.swift
//  GreatFeelSwiftUI
//
//  Background audio playback using AVFoundation
//

import Foundation
import AVFoundation
import Combine

class AudioPlayerService: ObservableObject {
    static let shared = AudioPlayerService()

    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var currentTrack: String?

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()

    private init() {
        setupAudioSession()
        setupNotifications()
    }

    // MARK: - Setup
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
            print("✅ Audio session setup successful")
        } catch {
            print("❌ Failed to setup audio session: \(error)")
            print("   Error details: \(error.localizedDescription)")
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                self?.handlePlaybackEnd()
            }
            .store(in: &cancellables)
    }

    // MARK: - Playback Control
    func play(url: String) {
        print("🎵 Attempting to play audio from URL: \(url)")

        guard let audioURL = URL(string: url) else {
            print("❌ Invalid audio URL: \(url)")
            return
        }

        // Stop current player if any
        stop()

        do {
            // Create new player
            let playerItem = AVPlayerItem(url: audioURL)
            player = AVPlayer(playerItem: playerItem)

            // Setup time observer
            setupTimeObserver()

            // Get duration
            playerItem.publisher(for: \.duration)
                .sink { [weak self] duration in
                    self?.duration = CMTimeGetSeconds(duration)
                }
                .store(in: &cancellables)

            // Play
            player?.play()
            isPlaying = true
            currentTrack = url
            print("✅ Audio playback started successfully")
        } catch {
            print("❌ Failed to play audio: \(error)")
            print("   Error details: \(error.localizedDescription)")
        }
    }

    func pause() {
        player?.pause()
        isPlaying = false
    }

    func resume() {
        player?.play()
        isPlaying = true
    }

    func stop() {
        player?.pause()
        player = nil
        isPlaying = false
        currentTime = 0
        duration = 0
        currentTrack = nil

        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }

    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        player?.seek(to: cmTime)
    }

    func setVolume(_ volume: Float) {
        player?.volume = volume
    }

    // MARK: - Private Helpers
    private func setupTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            self?.currentTime = CMTimeGetSeconds(time)
        }
    }

    private func handlePlaybackEnd() {
        // Loop the audio
        player?.seek(to: .zero)
        player?.play()
    }

    // MARK: - Background Audio
    func playBackgroundAudio(for mood: Mood, isMuted: Bool = false) {
        print("🎵 playBackgroundAudio called - Mood: \(mood), isMuted: \(isMuted)")

        if isMuted {
            print("🔇 Audio is muted, stopping playback")
            stop()
            return
        }

        play(url: mood.audioUrl)
        setVolume(0.3) // Set to 30% volume for background
    }
}
