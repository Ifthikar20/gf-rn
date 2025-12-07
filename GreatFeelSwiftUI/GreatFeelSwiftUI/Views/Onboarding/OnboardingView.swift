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
            // Gradient background
            LinearGradient(
                colors: [
                    Color(hex: "#F3F4F6"),
                    Color(hex: "#E5E7EB")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if showCompletion {
                CompletionView(isPresented: $isPresented)
            } else {
                VStack(spacing: 0) {
                    // Progress indicator
                    HStack(spacing: 8) {
                        ForEach(0..<OnboardingQuestion.allQuestions.count, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(index <= currentQuestionIndex ?
                                      Color(hex: "#6366F1") : Color.gray.opacity(0.3))
                                .frame(height: 4)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 60)

                    Spacer()

                    // Character
                    VStack(spacing: 20) {
                        // Character with bounce
                        if let image = UIImage(named: "welcome-character") {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .offset(y: characterBounce)
                        } else {
                            // Fallback
                            Image(systemName: "figure.mind.and.body")
                                .font(.system(size: 100))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .offset(y: characterBounce)
                        }

                        // Speech bubble with question
                        VStack(spacing: 0) {
                            // Triangle pointer
                            Triangle()
                                .fill(Color.white)
                                .frame(width: 25, height: 12)
                                .offset(y: 1)

                            // Question box
                            VStack(spacing: 16) {
                                HStack(spacing: 8) {
                                    Image(systemName: currentQuestion.icon)
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(hex: "#F59E0B"))

                                    Text(currentQuestion.question)
                                        .font(.system(size: 24, weight: .bold, design: .rounded))
                                        .foregroundColor(Color(hex: "#1F2937"))
                                        .multilineTextAlignment(.center)

                                    Image(systemName: currentQuestion.icon)
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(hex: "#F59E0B"))
                                }
                                .padding(.horizontal, 8)
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 8)
                            )
                        }
                        .padding(.horizontal, 32)
                    }

                    Spacer().frame(height: 40)

                    // Options
                    VStack(spacing: 12) {
                        ForEach(currentQuestion.options, id: \.self) { option in
                            OptionButton(
                                title: option,
                                isSelected: currentQuestion.allowsMultipleSelection ?
                                    selectedMultipleOptions.contains(option) :
                                    selectedOption == option,
                                action: {
                                    withAnimation(.spring(response: 0.3)) {
                                        if currentQuestion.allowsMultipleSelection {
                                            // Toggle selection for multiple choice
                                            if selectedMultipleOptions.contains(option) {
                                                selectedMultipleOptions.remove(option)
                                            } else {
                                                selectedMultipleOptions.insert(option)
                                            }
                                        } else {
                                            // Single selection
                                            selectedOption = option
                                        }

                                        // Character bounce on selection
                                        withAnimation(
                                            .easeInOut(duration: 0.4)
                                                .repeatCount(2, autoreverses: true)
                                        ) {
                                            characterBounce = -15
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                            characterBounce = 0
                                        }
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 32)

                    // Multiple selection hint
                    if currentQuestion.allowsMultipleSelection {
                        Text("Select all that apply")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#6B7280"))
                            .padding(.top, 8)
                    }

                    Spacer()

                    // Next Button
                    Button(action: handleNext) {
                        HStack(spacing: 12) {
                            Text(isLastQuestion ? "Complete" : "Next")
                                .font(.system(size: 20, weight: .bold, design: .rounded))

                            Image(systemName: isLastQuestion ? "checkmark.circle.fill" : "arrow.right.circle.fill")
                                .font(.system(size: 20))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: canProceed ?
                                    [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")] :
                                    [Color.gray, Color.gray],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(20)
                        .shadow(color: (canProceed ? Color(hex: "#8B5CF6") : Color.gray).opacity(0.3),
                                radius: 10, x: 0, y: 5)
                    }
                    .disabled(!canProceed)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
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

// MARK: - Option Button
struct OptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(isSelected ? Color(hex: "#6366F1") : Color(hex: "#4B5563"))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    isSelected ? Color(hex: "#6366F1") : Color.gray.opacity(0.3),
                                    lineWidth: isSelected ? 2.5 : 1.5
                                )
                        )
                        .shadow(color: isSelected ? Color(hex: "#6366F1").opacity(0.2) : .clear,
                                radius: 8, x: 0, y: 4)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Completion View
struct CompletionView: View {
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 0.5
    @State private var rotation: Double = 0

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Success animation
            ZStack {
                // Outer circles
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .stroke(Color(hex: "#6366F1").opacity(0.3), lineWidth: 2)
                        .frame(width: 120 + CGFloat(index * 40))
                        .scaleEffect(scale)
                }

                // Character or icon
                if let image = UIImage(named: "welcome-character") {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(rotation))
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(Color(hex: "#6366F1"))
                }
            }
            .scaleEffect(scale)

            VStack(spacing: 16) {
                Text("All set!")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                Text("Ready to start your wellness journey?")
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "#6B7280"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()

            // Start Button
            Button(action: {
                UserDefaultsService.shared.hasCompletedOnboarding = true
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isPresented = false
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "star.fill")
                    Text("Begin Journey")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    LinearGradient(
                        colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: Color(hex: "#8B5CF6").opacity(0.5), radius: 15, x: 0, y: 8)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                scale = 1.0
            }
            withAnimation(
                .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: false)
            ) {
                rotation = 360
            }
        }
    }
}

// MARK: - Triangle Shape (for speech bubble pointer)
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}
