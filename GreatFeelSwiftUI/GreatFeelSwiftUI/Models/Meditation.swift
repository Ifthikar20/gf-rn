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
        // Featured - Video Content with local assets
        MeditationSession(
            id: "m_local_1",
            title: "Cozy Comfort Session",
            description: "Embrace warmth and comfort with gentle movements and soothing guidance",
            category: .mindfulness,
            duration: 12,
            coverImage: "women-cudly-1",
            audioUrl: nil,
            videoUrl: "women-cudly-video",
            contentType: .video,
            instructor: "Emma Thompson",
            isFeatured: true,
            isPopular: true,
            isEditorsPick: true
        ),
        MeditationSession(
            id: "m_local_2",
            title: "Peaceful Evening Ritual",
            description: "Wind down your day with this calming evening meditation practice",
            category: .sleepSounds,
            duration: 15,
            coverImage: "women-cudly-2",
            audioUrl: nil,
            videoUrl: "women-cudly-video-1",
            contentType: .video,
            instructor: "Emma Thompson",
            isFeatured: true,
            isPopular: true,
            isEditorsPick: false
        ),
        MeditationSession(
            id: "m_local_3",
            title: "Gentle Morning Stretch",
            description: "Start your day with gentle stretches and mindful breathing",
            category: .breathingExercises,
            duration: 10,
            coverImage: "women-cudly-3",
            audioUrl: "https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3",
            videoUrl: nil,
            contentType: .audio,
            instructor: "Emma Thompson",
            isFeatured: true,
            isPopular: false,
            isEditorsPick: true
        ),
        MeditationSession(
            id: "m_local_4",
            title: "Afternoon Reset",
            description: "Take a midday break to reset and recharge your energy",
            category: .mindfulness,
            duration: 8,
            coverImage: "women-cudly-4",
            audioUrl: "https://cdn.pixabay.com/download/audio/2022/03/10/audio_c610232532.mp3",
            videoUrl: nil,
            contentType: .audio,
            instructor: "Emma Thompson",
            isFeatured: false,
            isPopular: true,
            isEditorsPick: false
        ),
        MeditationSession(
            id: "m_local_5",
            title: "Deep Relaxation",
            description: "Release tension and find complete relaxation in this guided session",
            category: .guidedMeditation,
            duration: 20,
            coverImage: "women-cudly-5",
            audioUrl: "https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3",
            videoUrl: nil,
            contentType: .audio,
            instructor: "Emma Thompson",
            isFeatured: false,
            isPopular: true,
            isEditorsPick: true
        ),
        MeditationSession(
            id: "m_local_6",
            title: "Stress Relief Flow",
            description: "Let go of daily stress with this flowing meditation practice",
            category: .mindfulness,
            duration: 14,
            coverImage: "women-cudly-6",
            audioUrl: "https://cdn.pixabay.com/download/audio/2022/03/10/audio_c610232532.mp3",
            videoUrl: nil,
            contentType: .audio,
            instructor: "Emma Thompson",
            isFeatured: false,
            isPopular: false,
            isEditorsPick: true
        ),
        MeditationSession(
            id: "m_local_7",
            title: "Bedtime Serenity",
            description: "Prepare for restful sleep with this peaceful evening meditation",
            category: .sleepSounds,
            duration: 18,
            coverImage: "women-cudly-7",
            audioUrl: "https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3",
            videoUrl: nil,
            contentType: .audio,
            instructor: "Emma Thompson",
            isFeatured: false,
            isPopular: true,
            isEditorsPick: false
        ),

        // Original Sessions
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
        ),
        // Additional Video Sessions
        MeditationSession(
            id: "m10",
            title: "Ocean Sunset Meditation",
            description: "Experience the tranquility of sunset by the ocean with guided breathing exercises",
            category: .oceanWaves,
            duration: 25,
            coverImage: "https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=400",
            audioUrl: nil,
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
            contentType: .video,
            instructor: "Lisa Anderson",
            isFeatured: false,
            isPopular: true,
            isEditorsPick: false
        ),
        MeditationSession(
            id: "m11",
            title: "Mindful Nature Walk",
            description: "Immerse yourself in nature's beauty with this mindful walking meditation",
            category: .natureSounds,
            duration: 30,
            coverImage: "https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400",
            audioUrl: nil,
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
            contentType: .video,
            instructor: "David Lee",
            isFeatured: true,
            isPopular: false,
            isEditorsPick: false
        ),
        MeditationSession(
            id: "m12",
            title: "Mountain Zen Journey",
            description: "Find inner peace with breathtaking mountain vistas and calming meditation",
            category: .mountainZen,
            duration: 35,
            coverImage: "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400",
            audioUrl: nil,
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
            contentType: .video,
            instructor: "Maya Patel",
            isFeatured: false,
            isPopular: true,
            isEditorsPick: true
        ),
        MeditationSession(
            id: "m13",
            title: "Chakra Awakening",
            description: "Visual journey through your chakras with guided energy alignment meditation",
            category: .chakraMeditation,
            duration: 28,
            coverImage: "https://images.unsplash.com/photo-1588286840104-8957b019727f?w=400",
            audioUrl: nil,
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
            contentType: .video,
            instructor: "Emma Wilson",
            isFeatured: false,
            isPopular: false,
            isEditorsPick: true
        ),
        MeditationSession(
            id: "m14",
            title: "Bedtime Stories",
            description: "Gentle bedtime meditation to help you drift into peaceful sleep",
            category: .sleepSounds,
            duration: 18,
            coverImage: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400",
            audioUrl: nil,
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
            contentType: .video,
            instructor: "Sarah Mitchell",
            isFeatured: false,
            isPopular: true,
            isEditorsPick: false
        ),
        MeditationSession(
            id: "m15",
            title: "Breathwork Mastery",
            description: "Master the art of conscious breathing with visual guidance and techniques",
            category: .breathingExercises,
            duration: 22,
            coverImage: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400",
            audioUrl: nil,
            videoUrl: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
            contentType: .video,
            instructor: "Michael Chen",
            isFeatured: false,
            isPopular: true,
            isEditorsPick: false
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
