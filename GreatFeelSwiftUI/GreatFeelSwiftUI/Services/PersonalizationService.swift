//
//  PersonalizationService.swift
//  GreatFeelSwiftUI
//
//  Created by Claude Code
//  Service for providing personalized content based on user onboarding responses
//

import Foundation

class PersonalizationService {
    static let shared = PersonalizationService()

    private init() {}

    // MARK: - Personalized Welcome Message

    func getWelcomeMessage() -> String {
        guard let data = UserDefaultsService.shared.onboardingData,
              let emotionalState = data.emotionalState else {
            return "Welcome! We're here to support your wellness journey."
        }

        return emotionalState.personalizedMessage
    }

    // MARK: - Recommended Content Categories

    func getRecommendedCategories() -> [String] {
        var categories: [String] = []

        guard let data = UserDefaultsService.shared.onboardingData else {
            return ["mindfulness", "meditation", "stress", "sleep"]
        }

        // Add categories based on emotional state
        if let emotionalState = data.emotionalState {
            categories.append(contentsOf: emotionalState.recommendedCategories)
        }

        // Add category based on primary goal
        if let primaryGoal = data.primaryGoal {
            switch primaryGoal {
            case .reduceStress:
                categories.append(contentsOf: ["breathing", "relaxation"])
            case .improveSleep:
                categories.append(contentsOf: ["sleep", "meditation"])
            case .buildMindfulness:
                categories.append(contentsOf: ["mindfulness", "meditation"])
            case .justExploring:
                categories.append(contentsOf: ["introduction", "basics"])
            }
        }

        // Remove duplicates and return unique categories
        return Array(Set(categories))
    }

    // MARK: - Recommended Session Duration

    func getRecommendedSessionDuration() -> Int {
        guard let data = UserDefaultsService.shared.onboardingData,
              let timeCommitment = data.timeCommitment else {
            return 10 // Default 10 minutes
        }

        return timeCommitment.recommendedSessionLength
    }

    // MARK: - Content Difficulty Level

    func getRecommendedDifficulty() -> String {
        guard let data = UserDefaultsService.shared.onboardingData,
              let experienceLevel = data.experienceLevel else {
            return "beginner"
        }

        return experienceLevel.recommendedDifficulty
    }

    // MARK: - Personalized Onboarding Summary

    func getOnboardingSummary() -> OnboardingSummary? {
        guard let data = UserDefaultsService.shared.onboardingData else {
            return nil
        }

        return OnboardingSummary(
            welcomeMessage: getWelcomeMessage(),
            recommendedCategories: getRecommendedCategories(),
            sessionDuration: getRecommendedSessionDuration(),
            difficultyLevel: getRecommendedDifficulty(),
            preferredActivities: data.preferredActivities.map { $0.rawValue },
            primaryGoal: data.primaryGoal?.rawValue ?? "Just exploring"
        )
    }

    // MARK: - Activity-Based Recommendations

    func getRecommendedContentTypes() -> [String] {
        guard let data = UserDefaultsService.shared.onboardingData else {
            return ["meditation", "article", "audio"]
        }

        var contentTypes: [String] = []

        for activity in data.preferredActivities {
            switch activity {
            case .guidedMeditation:
                contentTypes.append("meditation")
            case .breathingExercises:
                contentTypes.append("breathing")
            case .relaxingSounds:
                contentTypes.append("audio")
            case .journaling:
                contentTypes.append("article")
            case .mindfulMovement:
                contentTypes.append("video")
            case .readingArticles:
                contentTypes.append("article")
            }
        }

        return Array(Set(contentTypes))
    }

    // MARK: - Personalized Tips

    func getDailyTip() -> String {
        guard let data = UserDefaultsService.shared.onboardingData else {
            return "Take a moment to breathe deeply and center yourself."
        }

        if let primaryGoal = data.primaryGoal {
            switch primaryGoal {
            case .reduceStress:
                return "Try the 4-7-8 breathing technique: breathe in for 4, hold for 7, exhale for 8."
            case .improveSleep:
                return "Create a bedtime routine: dim lights, put away devices, and practice relaxation."
            case .buildMindfulness:
                return "Practice mindful eating: pay attention to each bite, savor the flavors."
            case .justExploring:
                return "Start small: even 5 minutes of mindfulness can make a difference."
            }
        }

        return "Remember to be kind to yourself today."
    }

    // MARK: - Check if Onboarding is Complete

    func hasCompletedOnboarding() -> Bool {
        return UserDefaultsService.shared.onboardingData != nil
    }

    // MARK: - Reset Onboarding (for testing or user preference change)

    func resetOnboarding() {
        UserDefaultsService.shared.onboardingData = nil
        UserDefaultsService.shared.hasCompletedOnboarding = false
        UserDefaultsService.shared.hasSeenWelcome = false
    }
}

// MARK: - Onboarding Summary Model

struct OnboardingSummary {
    let welcomeMessage: String
    let recommendedCategories: [String]
    let sessionDuration: Int
    let difficultyLevel: String
    let preferredActivities: [String]
    let primaryGoal: String

    var description: String {
        """
        📊 Your Personalized Profile:

        🎯 Goal: \(primaryGoal)
        ⏱️ Session Duration: \(sessionDuration) minutes
        📈 Difficulty: \(difficultyLevel)

        🎨 Interests:
        \(preferredActivities.map { "   • \($0)" }.joined(separator: "\n"))

        📚 Recommended Categories:
        \(recommendedCategories.prefix(5).map { "   • \($0.capitalized)" }.joined(separator: "\n"))
        """
    }
}
