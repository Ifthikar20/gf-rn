//
//  Mood.swift
//  GreatFeelSwiftUI
//
//  Mood and theming models
//

import Foundation

// MARK: - Mood
enum Mood: String, Codable, CaseIterable, Identifiable {
    case happy = "Happy"
    case calm = "Calm"
    case nervous = "Nervous"
    case sad = "Sad"
    case energetic = "Energetic"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .calm: return "😌"
        case .nervous: return "😰"
        case .sad: return "😢"
        case .energetic: return "⚡"
        }
    }

    var backgroundImageLight: String {
        switch self {
        case .happy:
            return "https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=1080"
        case .calm:
            return "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=1080"
        case .nervous:
            return "https://images.unsplash.com/photo-1541480601022-2308c0f02487?w=1080"
        case .sad:
            return "https://images.unsplash.com/photo-1428908728789-d2de25dbd4e2?w=1080"
        case .energetic:
            return "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=1080"
        }
    }

    var backgroundImageDark: String {
        switch self {
        case .happy:
            return "https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=1080"
        case .calm:
            return "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=1080"
        case .nervous:
            return "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1080"
        case .sad:
            return "https://images.unsplash.com/photo-1502139214982-d0ad755818d8?w=1080"
        case .energetic:
            return "https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=1080"
        }
    }

    var audioUrl: String {
        switch self {
        case .happy:
            return "https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3"
        case .calm:
            return "https://cdn.pixabay.com/download/audio/2022/03/10/audio_c610232532.mp3"
        case .nervous:
            return "https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3"
        case .sad:
            return "https://cdn.pixabay.com/download/audio/2022/03/10/audio_c610232532.mp3"
        case .energetic:
            return "https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3"
        }
    }

    func backgroundImage(for colorScheme: ColorScheme) -> String {
        colorScheme == .dark ? backgroundImageDark : backgroundImageLight
    }
}

// MARK: - Theme Mode
enum ThemeMode: String, Codable, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case auto = "Auto"

    var id: String { rawValue }
}

// MARK: - Color Scheme Extension
extension ColorScheme {
    var isDark: Bool {
        self == .dark
    }
}
