//
//  OnboardingQuestion.swift
//  GreatFeelSwiftUI
//
//  Created by Claude Code
//

import SwiftUI

// MARK: - Onboarding Question Model
struct OnboardingQuestion: Identifiable {
    let id = UUID()
    let question: String
    let options: [String]
    let icon: String
    let allowsMultipleSelection: Bool

    init(question: String, options: [String], icon: String, allowsMultipleSelection: Bool = false) {
        self.question = question
        self.options = options
        self.icon = icon
        self.allowsMultipleSelection = allowsMultipleSelection
    }
}

// MARK: - Onboarding Questions Data
extension OnboardingQuestion {
    static let allQuestions: [OnboardingQuestion] = [
        // Question 1: Emotional State
        OnboardingQuestion(
            question: "How have you been feeling lately?",
            options: [
                "Going through something difficult recently",
                "Ongoing mental health challenges",
                "Doing okay"
            ],
            icon: "heart.fill"
        ),

        // Question 2: Primary Goal
        OnboardingQuestion(
            question: "What brings you here today?",
            options: [
                "Reduce stress and anxiety",
                "Improve sleep quality",
                "Build mindfulness habits",
                "Just exploring"
            ],
            icon: "star.fill"
        ),

        // Question 3: Time Commitment
        OnboardingQuestion(
            question: "How much time can you dedicate daily?",
            options: [
                "5-10 minutes",
                "10-20 minutes",
                "20-30 minutes",
                "Flexible timing"
            ],
            icon: "clock.fill"
        ),

        // Question 4: Experience Level
        OnboardingQuestion(
            question: "What's your experience with mindfulness?",
            options: [
                "New to mindfulness & meditation",
                "I've tried it a few times",
                "I practice regularly",
                "Very experienced"
            ],
            icon: "lightbulb.fill"
        ),

        // Question 5: Preferred Activities (Multiple selection)
        OnboardingQuestion(
            question: "What activities interest you most?",
            options: [
                "Guided meditation",
                "Breathing exercises",
                "Relaxing sounds & music",
                "Journaling & reflection",
                "Mindful movement",
                "Reading articles"
            ],
            icon: "sparkles",
            allowsMultipleSelection: true
        )
    ]
}
