//
//  Meditation.swift
//  GreatFeelSwiftUI
//
//  Meditation and relaxation models
//

import Foundation

// MARK: - Meditation Session
struct MeditationSession: Codable, Identifiable {
    let id: String
    let title: String
    let description: String?
    let category: MeditationCategory
    let duration: Int // in minutes
    let coverImage: String?
    let audioUrl: String?
    let videoUrl: String?
    let contentType: SessionContentType
    let instructor: String?
    let isFeatured: Bool
    let isPopular: Bool
    let isEditorsPick: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, description, category, duration
        case coverImage, audioUrl, videoUrl, contentType, instructor
        case isFeatured, isPopular, isEditorsPick
    }
}

// MARK: - Session Content Type
enum SessionContentType: String, Codable {
    case audio = "Audio"
    case video = "Video"

    var displayLabel: String {
        switch self {
        case .audio: return "Relaxation"
        case .video: return "Discover"
        }
    }
}

// MARK: - Meditation Category
enum MeditationCategory: String, Codable, CaseIterable {
    case natureSounds = "Nature sounds"
    case oceanWaves = "Ocean waves"
    case rainSounds = "Rain sounds"
    case forestAmbience = "Forest ambience"
    case guidedMeditation = "Guided meditation"
    case sleepSounds = "Sleep sounds"
    case mindfulness = "Mindfulness"
    case breathingExercises = "Breathing exercises"
    case chakraMeditation = "Chakra meditation"
    case whiteNoise = "White noise"
    case thunderstorm = "Thunderstorm"
    case mountainZen = "Mountain zen"

    var icon: String {
        switch self {
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

// MARK: - Mock Meditation Sessions
extension MeditationSession {
    static let mockSessions: [MeditationSession] = [
        // Featured
        MeditationSession(
            id: "m1",
            title: "Ocean Waves at Sunset",
            description: "Relax to the gentle sound of ocean waves",
            category: .oceanWaves,
            duration: 30,
            coverImage: "https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=400",
            audioUrl: "https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3",
            videoUrl: nil,
            contentType: .audio,
            instructor: nil,
            isFeatured: true,
            isPopular: false,
            isEditorsPick: false
        ),
        MeditationSession(
            id: "m2",
            title: "Peaceful Rain",
            description: "Let the rain wash away your stress",
            category: .rainSounds,
            duration: 45,
            coverImage: "https://images.unsplash.com/photo-1428908728789-d2de25dbd4e2?w=400",
            audioUrl: "https://cdn.pixabay.com/download/audio/2022/03/10/audio_c610232532.mp3",
            videoUrl: nil,
            contentType: .audio,
            instructor: nil,
            isFeatured: true,
            isPopular: true,
            isEditorsPick: false
        ),
        MeditationSession(
            id: "m3",
            title: "Forest Morning",
            description: "Wake up to the sounds of the forest",
            category: .forestAmbience,
            duration: 20,
            coverImage: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400",
            audioUrl: nil,
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            contentType: .video,
            instructor: nil,
            isFeatured: true,
            isPopular: false,
            isEditorsPick: true
        ),
        // Popular
        MeditationSession(
            id: "m4",
            title: "Guided Sleep Meditation",
            description: "Drift into peaceful sleep",
            category: .guidedMeditation,
            duration: 15,
            coverImage: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400",
            audioUrl: nil,
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
            contentType: .video,
            instructor: "Sarah Mitchell",
            isFeatured: false,
            isPopular: true,
            isEditorsPick: false
        ),
        MeditationSession(
            id: "m5",
            title: "Deep Breathing Exercise",
            description: "Calm your mind with breathing",
            category: .breathingExercises,
            duration: 10,
            coverImage: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400",
            audioUrl: nil,
            videoUrl: nil,
            contentType: .audio,
            instructor: "Michael Chen",
            isFeatured: false,
            isPopular: true,
            isEditorsPick: false
        ),
        MeditationSession(
            id: "m6",
            title: "White Noise for Focus",
            description: "Enhance concentration and focus",
            category: .whiteNoise,
            duration: 60,
            coverImage: "https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=400",
            audioUrl: nil,
            videoUrl: nil,
            contentType: .audio,
            instructor: nil,
            isFeatured: false,
            isPopular: true,
            isEditorsPick: false
        ),
        // Editor's Pick
        MeditationSession(
            id: "m7",
            title: "Chakra Balance",
            description: "Align your energy centers",
            category: .chakraMeditation,
            duration: 25,
            coverImage: "https://images.unsplash.com/photo-1588286840104-8957b019727f?w=400",
            audioUrl: nil,
            videoUrl: nil,
            contentType: .audio,
            instructor: "Emma Wilson",
            isFeatured: false,
            isPopular: false,
            isEditorsPick: true
        ),
        MeditationSession(
            id: "m8",
            title: "Mountain Serenity",
            description: "Find peace in the mountains",
            category: .mountainZen,
            duration: 30,
            coverImage: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400",
            audioUrl: nil,
            videoUrl: nil,
            contentType: .audio,
            instructor: nil,
            isFeatured: false,
            isPopular: false,
            isEditorsPick: true
        ),
        MeditationSession(
            id: "m9",
            title: "Thunderstorm Ambience",
            description: "Cozy up to distant thunder",
            category: .thunderstorm,
            duration: 40,
            coverImage: "https://images.unsplash.com/photo-1431440869543-efaf3388c585?w=400",
            audioUrl: nil,
            videoUrl: nil,
            contentType: .audio,
            instructor: nil,
            isFeatured: false,
            isPopular: false,
            isEditorsPick: true
        )
    ]

    static var featuredSessions: [MeditationSession] {
        mockSessions.filter { $0.isFeatured }
    }

    static var popularSessions: [MeditationSession] {
        mockSessions.filter { $0.isPopular }
    }

    static var editorsPickSessions: [MeditationSession] {
        mockSessions.filter { $0.isEditorsPick }
    }
}
