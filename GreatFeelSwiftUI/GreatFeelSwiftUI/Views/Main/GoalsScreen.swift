//
//  GoalsScreen.swift
//  GreatFeelSwiftUI
//
//  Redesigned Goals screen with timeline, mood setter, and animated tree
//

import SwiftUI

// MARK: - Animated Tree Component
struct AnimatedTreeView: View {
    @Binding var triggerWind: Bool

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topTrailing) {
                // Main Branch
                Path { path in
                    let w = proxy.size.width
                    let h = proxy.size.height

                    // Draw a stylistic branch coming from top right
                    path.move(to: CGPoint(x: w + 50, y: -50))
                    path.addCurve(
                        to: CGPoint(x: w * 0.4, y: h * 0.4),
                        control1: CGPoint(x: w * 0.8, y: h * 0.1),
                        control2: CGPoint(x: w * 0.6, y: h * 0.2)
                    )
                }
                .stroke(Color.black.opacity(0.3), style: StrokeStyle(lineWidth: 15, lineCap: .round))

                // Secondary Branch
                Path { path in
                    let w = proxy.size.width
                    let h = proxy.size.height
                    path.move(to: CGPoint(x: w * 0.7, y: h * 0.15))
                    path.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.6), control: CGPoint(x: w * 0.5, y: h * 0.3))
                }
                .stroke(Color.black.opacity(0.3), style: StrokeStyle(lineWidth: 8, lineCap: .round))

                // Leaves (Animated)
                LeafGroup(triggerWind: triggerWind, x: 0.4, y: 0.4)
                LeafGroup(triggerWind: triggerWind, x: 0.5, y: 0.6)
                LeafGroup(triggerWind: triggerWind, x: 0.6, y: 0.2)
                LeafGroup(triggerWind: triggerWind, x: 0.8, y: 0.3)
                LeafGroup(triggerWind: triggerWind, x: 0.3, y: 0.5)
            }
        }
        .allowsHitTesting(false) // Let touches pass through to the UI
    }
}

struct LeafGroup: View {
    var triggerWind: Bool
    var x: CGFloat
    var y: CGFloat
    @State private var sway: Double = 0.0

    var body: some View {
        GeometryReader { proxy in
            Image(systemName: "leaf.fill")
                .font(.system(size: 24))
                .foregroundColor(Color.black.opacity(0.4))
                .rotationEffect(.degrees(sway))
                .position(x: proxy.size.width * x, y: proxy.size.height * y)
                .onChange(of: triggerWind) { _ in
                    // Wind gust animation
                    withAnimation(.easeInOut(duration: 0.2).repeatCount(3, autoreverses: true)) {
                        sway = Double.random(in: -20...20)
                    }
                    // Settle back to gentle sway
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                            sway = 5.0
                        }
                    }
                }
                .onAppear {
                    // Initial gentle sway
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        sway = 5.0
                    }
                }
        }
    }
}

// MARK: - Mood Setter Component
struct MoodSetterSmall: View {
    @Binding var selectedMood: Int
    @Binding var triggerWind: Bool

    let moods = ["😊", "😐", "😔", "😠"]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<moods.count, id: \.self) { index in
                Button(action: {
                    selectedMood = index
                    triggerWind.toggle() // Trigger tree animation
                }) {
                    Text(moods[index])
                        .font(.title3)
                        .grayscale(selectedMood == index ? 0 : 1)
                        .opacity(selectedMood == index ? 1 : 0.5)
                        .padding(8)
                        .background(selectedMood == index ? Color.white.opacity(0.2) : Color.clear)
                        .clipShape(Circle())
                }
            }
        }
        .padding(6)
        .background(Color.white.opacity(0.1))
        .cornerRadius(25)
    }
}

// MARK: - Timeline Card Component
struct TimelineCard: View {
    let goal: Goal
    @Environment(\.colorScheme) var colorScheme
    let onTap: () -> Void
    let onToggleComplete: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    // Category Tag
                    HStack(spacing: 6) {
                        Image(systemName: goal.category.icon)
                        Text(goal.type.rawValue)
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(goal.category.color)

                    // Title & Subtitle
                    VStack(alignment: .leading, spacing: 4) {
                        Text(goal.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("\(goal.duration) min")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                // Lock or Completion Icon
                if goal.isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white.opacity(0.5))
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())
                } else {
                    Button(action: onToggleComplete) {
                        Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 30))
                            .foregroundColor(goal.isCompleted ? .green : .white.opacity(0.3))
                    }
                }
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [AppColors.Dark.cardGradientStart, AppColors.Dark.cardGradientEnd],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [goal.category.color.opacity(0.3), .clear],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .background(
                RadialGradient(
                    colors: [goal.category.color.opacity(0.15), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: 100
                )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Timeline Components
struct TimelineSection<Content: View>: View {
    let icon: String
    let title: String
    let content: Content

    init(icon: String, title: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            // Left Column (Icon and Line)
            VStack(spacing: 0) {
                // Header Icon
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.Dark.textMuted)
                    .frame(width: 24, height: 24)

                // Dashed Line
                DashedLineView()
                    .frame(width: 1)
                    .padding(.top, 8)
            }

            // Right Column (Content)
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppColors.Dark.textMuted)

                content
            }
        }
    }
}

struct TimelineConnector: View {
    let height: CGFloat

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            DashedLineView()
                .frame(width: 1, height: height)
                .padding(.leading, 12)
            Spacer()
        }
    }
}

struct DashedLineView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            .foregroundColor(AppColors.Dark.textMuted.opacity(0.3))
        }
    }
}

// MARK: - Main Goals Screen
struct GoalsScreen: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @StateObject private var viewModel = GoalsViewModel()
    @Environment(\.colorScheme) var colorScheme

    @State private var selectedMood = 0
    @State private var triggerTreeWind = false

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: colorScheme == .dark
                    ? [AppColors.Dark.deepNightStart, AppColors.Dark.deepNightEnd]
                    : [Color(hex: "F0F9FF"), Color(hex: "E0F2FE")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Animated Tree Overlay (only in dark mode)
            if colorScheme == .dark {
                AnimatedTreeView(triggerWind: $triggerTreeWind)
                    .ignoresSafeArea()
            }

            VStack(spacing: 0) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("My plan")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)

                        Text(formattedDate)
                            .font(.subheadline)
                            .foregroundColor(colorScheme == .dark ? AppColors.Dark.textMuted : AppColors.Light.textSecondary)

                        // Mood Setter
                        MoodSetterSmall(selectedMood: $selectedMood, triggerWind: $triggerTreeWind)
                            .padding(.top, 8)
                    }

                    Spacer()

                    // Stats Circle
                    ZStack {
                        Circle()
                            .stroke(
                                colorScheme == .dark
                                    ? Color.white.opacity(0.1)
                                    : Color.black.opacity(0.05),
                                lineWidth: 4
                            )
                            .frame(width: 60, height: 60)

                        Circle()
                            .trim(from: 0, to: viewModel.progressPercentage)
                            .stroke(
                                AngularGradient(
                                    colors: [
                                        AppColors.primary(for: colorScheme),
                                        AppColors.secondary(for: colorScheme),
                                        AppColors.Category.relax
                                    ],
                                    center: .center
                                ),
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(-90))

                        VStack(spacing: 2) {
                            Text("\(Int(viewModel.progressPercentage * 100))")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(AppColors.primary(for: colorScheme))
                            Text("%")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                // Timeline ScrollView
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {

                        // --- MORNING ---
                        if !viewModel.morningGoals.isEmpty {
                            TimelineSection(icon: "sun.haze.fill", title: "Morning") {
                                VStack(spacing: 16) {
                                    ForEach(viewModel.morningGoals) { goal in
                                        TimelineCard(
                                            goal: goal,
                                            onTap: {},
                                            onToggleComplete: {
                                                viewModel.toggleGoalCompletion(goal.id)
                                            }
                                        )
                                    }
                                }
                            }

                            TimelineConnector(height: 30)
                        }

                        // --- DAY ---
                        if !viewModel.dayGoals.isEmpty {
                            TimelineSection(icon: "sun.max.fill", title: "Day") {
                                VStack(spacing: 16) {
                                    ForEach(viewModel.dayGoals) { goal in
                                        TimelineCard(
                                            goal: goal,
                                            onTap: {},
                                            onToggleComplete: {
                                                viewModel.toggleGoalCompletion(goal.id)
                                            }
                                        )
                                    }
                                }
                            }

                            TimelineConnector(height: 30)
                        }

                        // --- EVENING ---
                        if !viewModel.eveningGoals.isEmpty {
                            TimelineSection(icon: "moon.fill", title: "Evening") {
                                VStack(spacing: 16) {
                                    ForEach(viewModel.eveningGoals) { goal in
                                        TimelineCard(
                                            goal: goal,
                                            onTap: {},
                                            onToggleComplete: {
                                                viewModel.toggleGoalCompletion(goal.id)
                                            }
                                        )
                                    }
                                }
                            }
                        }

                        Spacer().frame(height: 100)
                    }
                    .padding(20)
                }
            }
        }
        .onAppear {
            viewModel.loadGoals()
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: Date())
    }
}

// MARK: - Preview
#Preview {
    GoalsScreen()
        .environmentObject(ThemeViewModel())
        .preferredColorScheme(.dark)
}
