//
//  Goal.swift
//  GreatFeelSwiftUI
//
//  Goals and daily planning models
//

import Foundation
import SwiftUI

// MARK: - Goal
struct Goal: Codable, Identifiable {
    let id: String
    let title: String
    let description: String?
    let type: GoalType
    let category: GoalCategory
    let duration: Int // in minutes
    let thumbnail: String?
    let timeOfDay: TimeOfDay
    let isLocked: Bool
    let isCompleted: Bool
    let streak: Int?
    let wellnessPoints: Int // Points earned on completion

    enum CodingKeys: String, CodingKey {
        case id, title, description, type, category, duration
        case thumbnail, timeOfDay, isLocked, isCompleted, streak, wellnessPoints
    }
}

// MARK: - Goal Type
enum GoalType: String, Codable, CaseIterable {
    case breath = "Breath"
    case meditation = "Meditation"
    case sleep = "Sleep story"
    case relax = "Relax music"
    case video = "Watch video"

    var icon: String {
        switch self {
        case .breath: return "wind"
        case .meditation: return "figure.mind.and.body"
        case .sleep: return "moon.stars.fill"
        case .relax: return "music.note"
        case .video: return "play.rectangle.fill"
        }
    }
}

// MARK: - Goal Category
enum GoalCategory: String, Codable, CaseIterable {
    case breath
    case meditation
    case sleep
    case relax
    case mindfulness
    case stress
    case anxiety
    case video

    var displayName: String {
        rawValue.capitalized
    }

    var icon: String {
        switch self {
        case .breath: return "wind"
        case .meditation: return "figure.mind.and.body"
        case .sleep: return "moon.stars.fill"
        case .relax: return "music.note"
        case .mindfulness: return "sparkles"
        case .stress: return "exclamationmark.triangle.fill"
        case .anxiety: return "heart.fill"
        case .video: return "play.rectangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .breath: return AppColors.Category.breath
        case .meditation: return AppColors.Category.meditation
        case .sleep: return AppColors.Category.sleep
        case .relax: return AppColors.Category.relax
        case .mindfulness: return AppColors.Category.mindfulness
        case .stress: return AppColors.Category.stress
        case .anxiety: return AppColors.Category.anxiety
        case .video: return AppColors.Category.productivity
        }
    }
}

// MARK: - Time of Day
enum TimeOfDay: String, Codable, CaseIterable {
    case morning = "Morning"
    case day = "Day"
    case evening = "Evening"

    var icon: String {
        switch self {
        case .morning: return "sun.max.fill"
        case .day: return "sun.min.fill"
        case .evening: return "moon.fill"
        }
    }

    var emoji: String {
        switch self {
        case .morning: return "☀️"
        case .day: return "☼"
        case .evening: return "☾"
        }
    }
}

// MARK: - Mock Goals
extension Goal {
    static let mockGoals: [Goal] = [
        Goal(
            id: "1",
            title: "Morning Meditation",
            description: "Start your day with mindfulness and positive energy",
            type: .meditation,
            category: .meditation,
            duration: 10,
            thumbnail: "women-cudly-1",
            timeOfDay: .morning,
            isLocked: false,
            isCompleted: false,
            streak: 5,
            wellnessPoints: 50
        ),
        Goal(
            id: "2",
            title: "Breathing Exercise",
            description: "Calm your mind with deep breaths and focused breathing",
            type: .breath,
            category: .breath,
            duration: 5,
            thumbnail: "women-cudly-2",
            timeOfDay: .morning,
            isLocked: false,
            isCompleted: true,
            streak: 3,
            wellnessPoints: 25
        ),
        Goal(
            id: "3",
            title: "Midday Relaxation",
            description: "Take a break and recharge with calming music",
            type: .relax,
            category: .relax,
            duration: 8,
            thumbnail: "women-cudly-3",
            timeOfDay: .day,
            isLocked: false,
            isCompleted: false,
            streak: nil,
            wellnessPoints: 40
        ),
        Goal(
            id: "4",
            title: "Stress Relief",
            description: "Release tension and find peace within",
            type: .meditation,
            category: .stress,
            duration: 13,
            thumbnail: "women-cudly-4",
            timeOfDay: .day,
            isLocked: true,
            isCompleted: false,
            streak: nil,
            wellnessPoints: 65
        ),
        Goal(
            id: "5",
            title: "Evening Wind Down",
            description: "Prepare for restful sleep with gentle relaxation",
            type: .sleep,
            category: .sleep,
            duration: 15,
            thumbnail: "women-cudly-5",
            timeOfDay: .evening,
            isLocked: false,
            isCompleted: false,
            streak: 7,
            wellnessPoints: 75
        ),
        Goal(
            id: "6",
            title: "Sleep Story",
            description: "Drift off to peaceful sleep with a soothing bedtime story",
            type: .sleep,
            category: .sleep,
            duration: 20,
            thumbnail: "women-cudly-6",
            timeOfDay: .evening,
            isLocked: true,
            isCompleted: false,
            streak: nil,
            wellnessPoints: 100
        ),
        Goal(
            id: "7",
            title: "Night Relaxation",
            description: "Calm music for peaceful rest and deep relaxation",
            type: .relax,
            category: .relax,
            duration: 30,
            thumbnail: "women-cudly-7",
            timeOfDay: .evening,
            isLocked: false,
            isCompleted: false,
            streak: 2,
            wellnessPoints: 150
        ),
        Goal(
            id: "8",
            title: "Morning Wellness Video",
            description: "Watch a guided wellness session to energize your day",
            type: .video,
            category: .video,
            duration: 15,
            thumbnail: "women-cudly-1",
            timeOfDay: .morning,
            isLocked: false,
            isCompleted: false,
            streak: nil,
            wellnessPoints: 80
        ),
        Goal(
            id: "9",
            title: "Mindfulness Tutorial",
            description: "Learn mindfulness techniques for daily practice",
            type: .video,
            category: .video,
            duration: 10,
            thumbnail: "women-cudly-2",
            timeOfDay: .day,
            isLocked: false,
            isCompleted: false,
            streak: 4,
            wellnessPoints: 50
        )
    ]
}
