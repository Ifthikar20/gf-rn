//
//  MeditationViewModel.swift
//  GreatFeelSwiftUI
//
//  Meditation sessions state management
//

import Foundation
import Combine

@MainActor
class MeditationViewModel: ObservableObject {
    @Published var sessions: [MeditationSession] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentlyPlayingSession: MeditationSession?

    private let audioService = AudioPlayerService.shared

    init() {
        loadSessions()
    }

    // MARK: - Load Sessions
    func loadSessions() {
        isLoading = true
        errorMessage = nil

        // Simulate network delay
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            sessions = MeditationSession.mockSessions
            isLoading = false
        }
    }

    // MARK: - Featured Sessions
    var featuredSessions: [MeditationSession] {
        sessions.filter { $0.isFeatured }
    }

    var popularSessions: [MeditationSession] {
        sessions.filter { $0.isPopular }
    }

    var editorsPickSessions: [MeditationSession] {
        sessions.filter { $0.isEditorsPick }
    }

    // MARK: - Sessions by Category
    func sessions(for category: MeditationCategory) -> [MeditationSession] {
        sessions.filter { $0.category == category }
    }

    // MARK: - Play Session
    func playSession(_ session: MeditationSession) {
        guard let audioUrl = session.audioUrl else { return }
        audioService.play(url: audioUrl)
        currentlyPlayingSession = session
    }

    func pauseSession() {
        audioService.pause()
    }

    func resumeSession() {
        audioService.resume()
    }

    func stopSession() {
        audioService.stop()
        currentlyPlayingSession = nil
    }

    var isPlaying: Bool {
        audioService.isPlaying
    }

    var currentTime: TimeInterval {
        audioService.currentTime
    }

    var duration: TimeInterval {
        audioService.duration
    }
}
