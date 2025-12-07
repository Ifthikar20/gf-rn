//
//  UserOnboardingData.swift
//  GreatFeelSwiftUI
//
//  Created by Claude Code
//  Model for storing user onboarding responses
//

import Foundation

// MARK: - User Onboarding Data Model
struct UserOnboardingData: Codable {
    // Question 1: Emotional state
    var emotionalState: EmotionalState?

    // Question 2: Primary goals
    var primaryGoal: PrimaryGoal?

    // Question 3: Time commitment
    var timeCommitment: TimeCommitment?

    // Question 4: Experience level
    var experienceLevel: ExperienceLevel?

    // Question 5: Preferred activities
    var preferredActivities: [ActivityType]

    // Timestamp
    var completedAt: Date

    init(
        emotionalState: EmotionalState? = nil,
        primaryGoal: PrimaryGoal? = nil,
        timeCommitment: TimeCommitment? = nil,
        experienceLevel: ExperienceLevel? = nil,
        preferredActivities: [ActivityType] = [],
        completedAt: Date = Date()
    ) {
        self.emotionalState = emotionalState
        self.primaryGoal = primaryGoal
        self.timeCommitment = timeCommitment
        self.experienceLevel = experienceLevel
        self.preferredActivities = preferredActivities
        self.completedAt = completedAt
    }
}

// MARK: - Emotional State
enum EmotionalState: String, Codable, CaseIterable {
    case difficultRecently = "Going through something difficult recently"
    case ongoingChallenges = "Ongoing mental health challenges"
    case doingOkay = "Doing okay"

    var personalizedMessage: String {
        switch self {
        case .difficultRecently:
            return "We're here to support you through this tough time."
        case .ongoingChallenges:
            return "Let's work together on building healthy coping strategies."
        case .doingOkay:
            return "Great! Let's help you maintain and improve your wellbeing."
        }
    }

    var recommendedCategories: [String] {
        switch self {
        case .difficultRecently:
            return ["stress", "anxiety", "sleep", "mindfulness"]
        case .ongoingChallenges:
            return ["mindfulness", "anxiety", "stress", "meditation"]
        case .doingOkay:
            return ["mindfulness", "sleep", "productivity", "meditation"]
        }
    }
}

// MARK: - Primary Goal
enum PrimaryGoal: String, Codable, CaseIterable {
    case reduceStress = "Reduce stress and anxiety"
    case improveSleep = "Improve sleep quality"
    case buildMindfulness = "Build mindfulness habits"
    case justExploring = "Just exploring"

    var icon: String {
        switch self {
        case .reduceStress: return "brain.head.profile"
        case .improveSleep: return "moon.stars.fill"
        case .buildMindfulness: return "leaf.fill"
        case .justExploring: return "sparkles"
        }
    }

    var recommendedContent: [String] {
        switch self {
        case .reduceStress:
            return ["breathing exercises", "stress management", "relaxation techniques"]
        case .improveSleep:
            return ["sleep meditation", "bedtime routine", "sleep hygiene"]
        case .buildMindfulness:
            return ["meditation basics", "mindful living", "daily practices"]
        case .justExploring:
            return ["introduction to wellness", "beginner's guide", "mixed content"]
        }
    }
}

// MARK: - Time Commitment
enum TimeCommitment: String, Codable, CaseIterable {
    case fiveToTen = "5-10 minutes"
    case tenToTwenty = "10-20 minutes"
    case twentyToThirty = "20-30 minutes"
    case flexible = "Flexible timing"

    var recommendedSessionLength: Int {
        switch self {
        case .fiveToTen: return 7
        case .tenToTwenty: return 15
        case .twentyToThirty: return 25
        case .flexible: return 15
        }
    }
}

// MARK: - Experience Level
enum ExperienceLevel: String, Codable, CaseIterable {
    case newToThis = "New to mindfulness & meditation"
    case somePractice = "I've tried it a few times"
    case regularPractice = "I practice regularly"
    case experienced = "Very experienced"

    var icon: String {
        switch self {
        case .newToThis: return "star.fill"
        case .somePractice: return "star.leadinghalf.filled"
        case .regularPractice: return "star.circle.fill"
        case .experienced: return "crown.fill"
        }
    }

    var recommendedDifficulty: String {
        switch self {
        case .newToThis: return "beginner"
        case .somePractice: return "beginner-intermediate"
        case .regularPractice: return "intermediate"
        case .experienced: return "advanced"
        }
    }
}

// MARK: - Activity Type
enum ActivityType: String, Codable, CaseIterable {
    case guidedMeditation = "Guided meditation"
    case breathingExercises = "Breathing exercises"
    case relaxingSounds = "Relaxing sounds & music"
    case journaling = "Journaling & reflection"
    case mindfulMovement = "Mindful movement"
    case readingArticles = "Reading articles"

    var icon: String {
        switch self {
        case .guidedMeditation: return "headphones"
        case .breathingExercises: return "wind"
        case .relaxingSounds: return "music.note"
        case .journaling: return "book.fill"
        case .mindfulMovement: return "figure.walk"
        case .readingArticles: return "text.book.closed.fill"
        }
    }
}

// MARK: - UserDefaults Extension
extension UserDefaultsService {
    private static let onboardingDataKey = "userOnboardingData"

    var onboardingData: UserOnboardingData? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Self.onboardingDataKey) else {
                return nil
            }
            return try? JSONDecoder().decode(UserOnboardingData.self, from: data)
        }
        set {
            if let newValue = newValue {
                let data = try? JSONEncoder().encode(newValue)
                UserDefaults.standard.set(data, forKey: Self.onboardingDataKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Self.onboardingDataKey)
            }
        }
    }
}
