//
//  Content.swift
//  GreatFeelSwiftUI
//
//  Library content models (articles, videos, audio)
//

import Foundation

// MARK: - Content Item
struct ContentItem: Codable, Identifiable {
    let id: String
    let title: String
    let description: String?
    let type: ContentType
    let category: ContentCategory
    let duration: Int? // in minutes or seconds
    let thumbnail: String?
    let url: String?
    let author: String?
    let viewCount: Int?
    let isBookmarked: Bool
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, title, description, type, category, duration
        case thumbnail, url, author, viewCount, isBookmarked, createdAt
    }
}

// MARK: - Content Type
enum ContentType: String, Codable, CaseIterable {
    case article = "Article"
    case video = "Video"
    case audio = "Audio"
    case meditation = "Meditation"

    var icon: String {
        switch self {
        case .article: return "doc.text.fill"
        case .video: return "play.rectangle.fill"
        case .audio: return "waveform"
        case .meditation: return "figure.mind.and.body"
        }
    }
}

// MARK: - Content Category
enum ContentCategory: String, Codable, CaseIterable {
    case mindfulness = "Mindfulness"
    case stress = "Stress"
    case sleep = "Sleep"
    case anxiety = "Anxiety"
    case depression = "Depression"
    case productivity = "Productivity"
    case relationships = "Relationships"
    case selfCare = "Self-care"
    case meditation = "Meditation"

    var displayName: String {
        rawValue
    }
}

// MARK: - Mock Content Items
extension ContentItem {
    static let mockArticles: [ContentItem] = [
        ContentItem(
            id: "a1",
            title: "5 Ways to Reduce Stress",
            description: "Practical techniques for managing daily stress",
            type: .article,
            category: .stress,
            duration: 5,
            thumbnail: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400",
            url: nil,
            author: "Dr. Sarah Johnson",
            viewCount: 1243,
            isBookmarked: false,
            createdAt: Date()
        ),
        ContentItem(
            id: "a2",
            title: "Mindfulness for Beginners",
            description: "Getting started with mindfulness meditation",
            type: .article,
            category: .mindfulness,
            duration: 8,
            thumbnail: "https://images.unsplash.com/photo-1499209974431-9dddcece7f88?w=400",
            url: nil,
            author: "Michael Chen",
            viewCount: 2156,
            isBookmarked: true,
            createdAt: Date()
        ),
        ContentItem(
            id: "a3",
            title: "Better Sleep Habits",
            description: "Improve your sleep quality naturally",
            type: .article,
            category: .sleep,
            duration: 6,
            thumbnail: "https://images.unsplash.com/photo-1541480601022-2308c0f02487?w=400",
            url: nil,
            author: "Emma Wilson",
            viewCount: 987,
            isBookmarked: false,
            createdAt: Date()
        )
    ]

    static let mockVideos: [ContentItem] = [
        ContentItem(
            id: "v1",
            title: "Guided Meditation Journey",
            description: "A peaceful 10-minute meditation session",
            type: .video,
            category: .meditation,
            duration: 10,
            thumbnail: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400",
            url: nil,
            author: "Meditation Masters",
            viewCount: 5432,
            isBookmarked: true,
            createdAt: Date()
        ),
        ContentItem(
            id: "v2",
            title: "Yoga for Stress Relief",
            description: "Gentle yoga poses to release tension",
            type: .video,
            category: .stress,
            duration: 15,
            thumbnail: "https://images.unsplash.com/photo-1588286840104-8957b019727f?w=400",
            url: nil,
            author: "Yoga Flow",
            viewCount: 3211,
            isBookmarked: false,
            createdAt: Date()
        )
    ]

    static let mockAudio: [ContentItem] = [
        ContentItem(
            id: "au1",
            title: "Ocean Waves",
            description: "Soothing ocean sounds for relaxation",
            type: .audio,
            category: .sleep,
            duration: 3600,
            thumbnail: "https://images.unsplash.com/photo-1505142468610-359e7d316be0?w=400",
            url: "https://cdn.pixabay.com/download/audio/2022/05/27/audio_1808fbf07a.mp3",
            author: "Nature Sounds",
            viewCount: 8765,
            isBookmarked: true,
            createdAt: Date()
        ),
        ContentItem(
            id: "au2",
            title: "Rain and Thunder",
            description: "Peaceful rain sounds with distant thunder",
            type: .audio,
            category: .sleep,
            duration: 3600,
            thumbnail: "https://images.unsplash.com/photo-1428908728789-d2de25dbd4e2?w=400",
            url: "https://cdn.pixabay.com/download/audio/2022/03/10/audio_c610232532.mp3",
            author: "Nature Sounds",
            viewCount: 6543,
            isBookmarked: false,
            createdAt: Date()
        )
    ]

    static let allMockContent: [ContentItem] = mockArticles + mockVideos + mockAudio
}
