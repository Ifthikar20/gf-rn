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

    enum CodingKeys: String, CodingKey {
        case id, title, description, type, category, duration
        case thumbnail, timeOfDay, isLocked, isCompleted, streak
    }
}

// MARK: - Goal Type
enum GoalType: String, Codable, CaseIterable {
    case breath = "Breath"
    case meditation = "Meditation"
    case sleep = "Sleep story"
    case relax = "Relax music"

    var icon: String {
        switch self {
        case .breath: return "wind"
        case .meditation: return "figure.mind.and.body"
        case .sleep: return "moon.stars.fill"
        case .relax: return "music.note"
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
            description: "Start your day with mindfulness",
            type: .meditation,
            category: .meditation,
            duration: 10,
            thumbnail: "women-cudly",
            timeOfDay: .morning,
            isLocked: false,
            isCompleted: false,
            streak: 5
        ),
        Goal(
            id: "2",
            title: "Breathing Exercise",
            description: "Calm your mind with deep breaths",
            type: .breath,
            category: .breath,
            duration: 5,
            thumbnail: "women-cudly-2",
            timeOfDay: .morning,
            isLocked: false,
            isCompleted: true,
            streak: 3
        ),
        Goal(
            id: "3",
            title: "Midday Relaxation",
            description: "Take a break and relax",
            type: .relax,
            category: .relax,
            duration: 8,
            thumbnail: "women-cudly-3",
            timeOfDay: .day,
            isLocked: false,
            isCompleted: false,
            streak: nil
        ),
        Goal(
            id: "4",
            title: "Stress Relief",
            description: "Release tension and stress",
            type: .meditation,
            category: .stress,
            duration: 13,
            thumbnail: "women-cudly-4",
            timeOfDay: .day,
            isLocked: true,
            isCompleted: false,
            streak: nil
        ),
        Goal(
            id: "5",
            title: "Evening Wind Down",
            description: "Prepare for restful sleep",
            type: .sleep,
            category: .sleep,
            duration: 15,
            thumbnail: "women-cudly-5",
            timeOfDay: .evening,
            isLocked: false,
            isCompleted: false,
            streak: 7
        ),
        Goal(
            id: "6",
            title: "Sleep Story",
            description: "Drift off to peaceful sleep",
            type: .sleep,
            category: .sleep,
            duration: 20,
            thumbnail: "women-cudly",
            timeOfDay: .evening,
            isLocked: true,
            isCompleted: false,
            streak: nil
        ),
        Goal(
            id: "7",
            title: "Night Relaxation",
            description: "Calm music for peaceful rest",
            type: .relax,
            category: .relax,
            duration: 30,
            thumbnail: "women-cudly-2",
            timeOfDay: .evening,
            isLocked: false,
            isCompleted: false,
            streak: 2
        )
    ]
}
