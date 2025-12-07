//
//  OnboardingView.swift
//  GreatFeelSwiftUI
//
//  Created by Claude Code
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [String] = []
    @State private var selectedOption: String? = nil
    @State private var selectedMultipleOptions: Set<String> = []
    @State private var characterBounce: CGFloat = 0
    @State private var showCompletion = false

    var currentQuestion: OnboardingQuestion {
        OnboardingQuestion.allQuestions[currentQuestionIndex]
    }

    var isLastQuestion: Bool {
        currentQuestionIndex == OnboardingQuestion.allQuestions.count - 1
    }

    var canProceed: Bool {
        if currentQuestion.allowsMultipleSelection {
            return !selectedMultipleOptions.isEmpty
        } else {
            return selectedOption != nil
        }
    }

    var body: some View {
        ZStack {
            // Warm beige background
            Color(hex: "#F5F1E8")
                .ignoresSafeArea()

            if showCompletion {
                CompletionView(isPresented: $isPresented)
            } else {
                VStack(spacing: 0) {
                    // Back button (placeholder for future navigation)
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(Color(hex: "#666666"))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                    // White card with question
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            // Icon with warm gradient
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "#F5A442"), Color(hex: "#E8914A")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 60, height: 60)

                                Image(systemName: currentQuestion.icon)
                                    .font(.system(size: 28, weight: .semibold))
                                    .foregroundColor(.white)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Question \(currentQuestionIndex + 1)/\(OnboardingQuestion.allQuestions.count)")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color(hex: "#E8A857"))

                                Text(currentQuestion.question)
                                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                                    .foregroundColor(Color(hex: "#2C3E50"))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.vertical, 32)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
                    .padding(.horizontal, 24)
                    .padding(.top, 24)

                    Spacer()

                    // Warm friendly options
                    VStack(spacing: 15) {
                        ForEach(currentQuestion.options, id: \.self) { option in
                            WarmOptionButton(
                                title: option,
                                isSelected: currentQuestion.allowsMultipleSelection ?
                                    selectedMultipleOptions.contains(option) :
                                    selectedOption == option,
                                action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        if currentQuestion.allowsMultipleSelection {
                                            if selectedMultipleOptions.contains(option) {
                                                selectedMultipleOptions.remove(option)
                                            } else {
                                                selectedMultipleOptions.insert(option)
                                            }
                                        } else {
                                            selectedOption = option
                                        }
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 24)

                    // Multiple selection hint
                    if currentQuestion.allowsMultipleSelection {
                        Text("Select all that apply")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(hex: "#666666"))
                            .padding(.top, 8)
                    }

                    Spacer()

                    // Warm gradient next button
                    Button(action: handleNext) {
                        Text(isLastQuestion ? "Complete" : "Next")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#F5A442"), Color(hex: "#E8914A")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(100)
                            .shadow(color: Color(hex: "#F5A442").opacity(0.3), radius: 6, x: 0, y: 4)
                            .opacity(canProceed ? 1.0 : 0.5)
                    }
                    .disabled(!canProceed)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                }
            }
        }
        .onAppear {
            // Start character bounce animation
            withAnimation(
                .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                characterBounce = -10
            }
        }
    }

    private func handleNext() {
        // Save answer(s)
        if currentQuestion.allowsMultipleSelection {
            // Save all selected options as comma-separated string
            let answer = selectedMultipleOptions.sorted().joined(separator: ", ")
            selectedAnswers.append(answer)
        } else {
            guard let answer = selectedOption else { return }
            selectedAnswers.append(answer)
        }

        if isLastQuestion {
            // Save all responses to UserDefaults
            saveOnboardingData()

            // Show completion
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showCompletion = true
            }
        } else {
            // Move to next question
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentQuestionIndex += 1
                selectedOption = nil
                selectedMultipleOptions.removeAll()
            }
        }
    }

    private func saveOnboardingData() {
        guard selectedAnswers.count == 5 else { return }

        var onboardingData = UserOnboardingData()

        // Question 1: Emotional State
        if let emotionalState = EmotionalState.allCases.first(where: { $0.rawValue == selectedAnswers[0] }) {
            onboardingData.emotionalState = emotionalState
        }

        // Question 2: Primary Goal
        if let primaryGoal = PrimaryGoal.allCases.first(where: { $0.rawValue == selectedAnswers[1] }) {
            onboardingData.primaryGoal = primaryGoal
        }

        // Question 3: Time Commitment
        if let timeCommitment = TimeCommitment.allCases.first(where: { $0.rawValue == selectedAnswers[2] }) {
            onboardingData.timeCommitment = timeCommitment
        }

        // Question 4: Experience Level
        if let experienceLevel = ExperienceLevel.allCases.first(where: { $0.rawValue == selectedAnswers[3] }) {
            onboardingData.experienceLevel = experienceLevel
        }

        // Question 5: Preferred Activities
        let activities = selectedAnswers[4].components(separatedBy: ", ")
        onboardingData.preferredActivities = activities.compactMap { activityString in
            ActivityType.allCases.first(where: { $0.rawValue == activityString })
        }

        // Save to UserDefaults
        UserDefaultsService.shared.onboardingData = onboardingData

        print("✅ Onboarding data saved successfully:")
        print("   Emotional State: \(onboardingData.emotionalState?.rawValue ?? "N/A")")
        print("   Primary Goal: \(onboardingData.primaryGoal?.rawValue ?? "N/A")")
        print("   Time Commitment: \(onboardingData.timeCommitment?.rawValue ?? "N/A")")
        print("   Experience Level: \(onboardingData.experienceLevel?.rawValue ?? "N/A")")
        print("   Preferred Activities: \(onboardingData.preferredActivities.map { $0.rawValue })")
    }
}

// MARK: - Warm Option Button
struct WarmOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "#2C3E50"))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 32)
                .padding(.vertical, 22)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(
                            isSelected ? Color(hex: "#E8A857") : Color(hex: "#E8E5DC"),
                            lineWidth: isSelected ? 3 : 2
                        )
                )
                .cornerRadius(100)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Completion View
struct CompletionView: View {
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 0.5
    @State private var showContent = false

    var body: some View {
        ZStack {
            // Warm beige background
            Color(hex: "#F5F1E8")
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Success checkmark with warm gradient
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#F5A442"), Color(hex: "#E8914A")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)

                    Image(systemName: "checkmark")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(scale)
                .shadow(color: Color(hex: "#F5A442").opacity(0.3), radius: 15, x: 0, y: 8)

                if showContent {
                    VStack(spacing: 16) {
                        Text("You're All Set!")
                            .font(.system(size: 36, weight: .heavy, design: .rounded))
                            .foregroundColor(Color(hex: "#2C3E50"))
                            .multilineTextAlignment(.center)

                        Text("Your personalized wellness journey begins now")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .foregroundColor(Color(hex: "#666666"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .transition(.opacity.combined(with: .offset(y: 20)))
                }

                Spacer()

                if showContent {
                    // Begin button
                    Button(action: {
                        UserDefaultsService.shared.hasCompletedOnboarding = true
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            isPresented = false
                        }
                    }) {
                        Text("Begin Your Journey")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#F5A442"), Color(hex: "#E8914A")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(100)
                            .shadow(color: Color(hex: "#F5A442").opacity(0.3), radius: 6, x: 0, y: 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 50)
                    .transition(.opacity.combined(with: .offset(y: 20)))
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showContent = true
                }
            }
        }
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}
