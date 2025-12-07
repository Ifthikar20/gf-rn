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
            // Modern dark animated background
            ModernAnimatedBackground()
                .ignoresSafeArea()

            if showCompletion {
                CompletionView(isPresented: $isPresented)
            } else {
                VStack(spacing: 0) {
                    // Modern progress indicator
                    HStack(spacing: 6) {
                        ForEach(0..<OnboardingQuestion.allQuestions.count, id: \.self) { index in
                            Capsule()
                                .fill(index <= currentQuestionIndex ?
                                      LinearGradient(
                                        colors: [Color(hex: "#8B5CF6"), Color(hex: "#EC4899")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                      ) :
                                      LinearGradient(
                                        colors: [Color.white.opacity(0.2), Color.white.opacity(0.1)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                      )
                                )
                                .frame(height: 4)
                                .shadow(color: index <= currentQuestionIndex ? Color(hex: "#8B5CF6").opacity(0.5) : .clear,
                                        radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 60)

                    Spacer()

                    // Modern Question Card
                    VStack(spacing: 24) {
                        // Animated icon
                        ZStack {
                            // Glowing background
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "#8B5CF6").opacity(0.3),
                                            Color(hex: "#EC4899").opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .blur(radius: 20)

                            // Icon container
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "#8B5CF6"), Color(hex: "#EC4899")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 80, height: 80)

                                Image(systemName: currentQuestion.icon)
                                    .font(.system(size: 36, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .offset(y: characterBounce)
                            .shadow(color: Color(hex: "#8B5CF6").opacity(0.5), radius: 20, x: 0, y: 10)
                        }

                        // Modern question card
                        VStack(spacing: 20) {
                            Text(currentQuestion.question)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, Color.white.opacity(0.9)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        }
                    }

                    Spacer().frame(height: 40)

                    // Modern Options
                    VStack(spacing: 14) {
                        ForEach(currentQuestion.options, id: \.self) { option in
                            ModernOptionButton(
                                title: option,
                                isSelected: currentQuestion.allowsMultipleSelection ?
                                    selectedMultipleOptions.contains(option) :
                                    selectedOption == option,
                                action: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
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

                                        // Icon bounce on selection
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
                    .padding(.horizontal, 28)

                    // Multiple selection hint
                    if currentQuestion.allowsMultipleSelection {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color(hex: "#EC4899"))
                            Text("Select all that apply")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 4)
                    }

                    Spacer()

                    // Modern Next Button
                    Button(action: handleNext) {
                        HStack(spacing: 12) {
                            Text(isLastQuestion ? "Complete Journey" : "Continue")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(.white)

                            Image(systemName: isLastQuestion ? "checkmark.circle.fill" : "arrow.right")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            Group {
                                if canProceed {
                                    LinearGradient(
                                        colors: [Color(hex: "#8B5CF6"), Color(hex: "#EC4899")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                } else {
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                            }
                        )
                        .cornerRadius(16)
                        .shadow(
                            color: canProceed ? Color(hex: "#8B5CF6").opacity(0.5) : .clear,
                            radius: 20,
                            x: 0,
                            y: 10
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    LinearGradient(
                                        colors: canProceed ?
                                            [Color.white.opacity(0.3), Color.white.opacity(0.1)] :
                                            [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                    }
                    .disabled(!canProceed)
                    .scaleEffect(canProceed ? 1.0 : 0.98)
                    .animation(.spring(response: 0.3), value: canProceed)
                    .padding(.horizontal, 28)
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

// MARK: - Modern Animated Background
struct ModernAnimatedBackground: View {
    @State private var animateGradient = false

    var body: some View {
        ZStack {
            // Base dark gradient
            LinearGradient(
                colors: [
                    Color(hex: "#0F172A"),
                    Color(hex: "#1E1B4B"),
                    Color(hex: "#312E81")
                ],
                startPoint: animateGradient ? .topLeading : .bottomLeading,
                endPoint: animateGradient ? .bottomTrailing : .topTrailing
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }

            // Animated orbs
            GeometryReader { geometry in
                ZStack {
                    // Purple orb
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(hex: "#8B5CF6").opacity(0.4),
                                    Color(hex: "#8B5CF6").opacity(0.0)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 200
                            )
                        )
                        .frame(width: 400, height: 400)
                        .offset(x: animateGradient ? -50 : 50, y: -100)
                        .blur(radius: 60)

                    // Pink orb
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(hex: "#EC4899").opacity(0.3),
                                    Color(hex: "#EC4899").opacity(0.0)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 200
                            )
                        )
                        .frame(width: 350, height: 350)
                        .offset(x: animateGradient ? 100 : -100, y: geometry.size.height / 2)
                        .blur(radius: 50)

                    // Blue orb
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color(hex: "#3B82F6").opacity(0.2),
                                    Color(hex: "#3B82F6").opacity(0.0)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                        .offset(x: animateGradient ? -80 : 80, y: geometry.size.height - 150)
                        .blur(radius: 40)
                }
            }
        }
    }
}

// MARK: - Modern Option Button
struct ModernOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Selection indicator
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: isSelected ?
                                    [Color(hex: "#8B5CF6"), Color(hex: "#EC4899")] :
                                    [Color.white.opacity(0.3), Color.white.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#8B5CF6"), Color(hex: "#EC4899")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 14, height: 14)
                            .transition(.scale)
                    }
                }

                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .medium, design: .rounded))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                ZStack {
                    // Glassmorphic effect
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#8B5CF6").opacity(0.3),
                                        Color(hex: "#EC4899").opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white.opacity(0.08))
                    }

                    // Border
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: isSelected ?
                                    [Color(hex: "#8B5CF6").opacity(0.6), Color(hex: "#EC4899").opacity(0.4)] :
                                    [Color.white.opacity(0.2), Color.white.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isSelected ? 2 : 1
                        )
                }
            )
            .shadow(
                color: isSelected ? Color(hex: "#8B5CF6").opacity(0.3) : .clear,
                radius: isSelected ? 15 : 0,
                x: 0,
                y: isSelected ? 8 : 0
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Completion View
struct CompletionView: View {
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 0.5
    @State private var particles: [Particle] = []
    @State private var showContent = false

    var body: some View {
        ZStack {
            // Modern dark background
            ModernAnimatedBackground()
                .ignoresSafeArea()

            // Particle effects
            ForEach(particles) { particle in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "#8B5CF6").opacity(0.8),
                                Color(hex: "#EC4899").opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .blur(radius: 2)
            }

            VStack(spacing: 40) {
                Spacer()

                // Success icon with glow
                ZStack {
                    // Glowing rings
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "#8B5CF6").opacity(0.4 - Double(index) * 0.1),
                                        Color(hex: "#EC4899").opacity(0.3 - Double(index) * 0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                            .frame(width: 140 + CGFloat(index * 50))
                            .scaleEffect(scale)
                            .blur(radius: 1)
                    }

                    // Center success icon
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "#8B5CF6"), Color(hex: "#EC4899")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)

                        Image(systemName: "checkmark")
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(scale)
                    .shadow(color: Color(hex: "#8B5CF6").opacity(0.6), radius: 30, x: 0, y: 15)
                }

                if showContent {
                    VStack(spacing: 20) {
                        Text("You're All Set!")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, Color.white.opacity(0.9)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .multilineTextAlignment(.center)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)

                        Text("Your personalized wellness journey begins now")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .transition(.opacity.combined(with: .offset(y: 20)))
                }

                Spacer()

                if showContent {
                    // Modern start button
                    Button(action: {
                        UserDefaultsService.shared.hasCompletedOnboarding = true
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            isPresented = false
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 18, weight: .semibold))
                            Text("Begin Your Journey")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 22)
                        .background(
                            LinearGradient(
                                colors: [Color(hex: "#8B5CF6"), Color(hex: "#EC4899")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                        .shadow(color: Color(hex: "#8B5CF6").opacity(0.5), radius: 25, x: 0, y: 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, 50)
                    .transition(.opacity.combined(with: .offset(y: 20)))
                }
            }
        }
        .onAppear {
            // Animate success icon
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
            }

            // Show content after icon animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showContent = true
                }
            }

            // Generate particles
            generateParticles()
        }
    }

    private func generateParticles() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height

        for _ in 0..<30 {
            let particle = Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight)
                ),
                size: CGFloat.random(in: 2...6)
            )
            particles.append(particle)
        }
    }
}

// MARK: - Particle Model
struct Particle: Identifiable {
    let id = UUID()
    let position: CGPoint
    let size: CGFloat
}

#Preview {
    OnboardingView(isPresented: .constant(true))
}
