//
//  ThemeViewModel.swift
//  GreatFeelSwiftUI
//
//  Theme and mood state management
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ThemeViewModel: ObservableObject {
    @Published var themeMode: ThemeMode {
        didSet {
            userDefaultsService.themeMode = themeMode
        }
    }

    @Published var selectedMood: Mood {
        didSet {
            userDefaultsService.selectedMood = selectedMood
            updateBackgroundAudio()
        }
    }

    @Published var isAudioMuted: Bool {
        didSet {
            userDefaultsService.isAudioMuted = isAudioMuted
            updateBackgroundAudio()
        }
    }

    @Published var colorScheme: ColorScheme = .light

    private let userDefaultsService = UserDefaultsService.shared
    private let audioService = AudioPlayerService.shared

    init() {
        self.themeMode = userDefaultsService.themeMode
        self.selectedMood = userDefaultsService.selectedMood
        self.isAudioMuted = userDefaultsService.isAudioMuted
        updateBackgroundAudio()
    }

    // MARK: - Theme Mode
    func setThemeMode(_ mode: ThemeMode) {
        themeMode = mode
    }

    func toggleDarkMode() {
        switch themeMode {
        case .light:
            themeMode = .dark
        case .dark:
            themeMode = .light
        case .auto:
            // If auto, switch to explicit mode based on current scheme
            themeMode = colorScheme == .dark ? .light : .dark
        }
    }

    // MARK: - Mood
    func selectMood(_ mood: Mood) {
        selectedMood = mood
    }

    // MARK: - Audio
    func toggleAudioMute() {
        isAudioMuted.toggle()
    }

    private func updateBackgroundAudio() {
        audioService.playBackgroundAudio(for: selectedMood, isMuted: isAudioMuted)
    }

    // MARK: - Computed Properties
    func backgroundImage(for scheme: ColorScheme) -> String {
        selectedMood.backgroundImage(for: scheme)
    }

    func shouldUseDarkMode(systemScheme: ColorScheme) -> Bool {
        switch themeMode {
        case .light:
            return false
        case .dark:
            return true
        case .auto:
            return systemScheme == .dark
        }
    }
}
