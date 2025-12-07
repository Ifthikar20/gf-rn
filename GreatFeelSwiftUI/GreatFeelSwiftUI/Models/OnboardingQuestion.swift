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
}

// MARK: - Onboarding Questions Data
extension OnboardingQuestion {
    static let allQuestions: [OnboardingQuestion] = [
        OnboardingQuestion(
            question: "How have you been feeling lately?",
            options: [
                "Going through something difficult recently",
                "Ongoing mental health challenges",
                "Doing okay"
            ],
            icon: "heart.fill"
        ),
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
        OnboardingQuestion(
            question: "How much time can you dedicate daily?",
            options: [
                "5-10 minutes",
                "10-20 minutes",
                "20-30 minutes",
                "Flexible timing"
            ],
            icon: "clock.fill"
        )
    ]
}
