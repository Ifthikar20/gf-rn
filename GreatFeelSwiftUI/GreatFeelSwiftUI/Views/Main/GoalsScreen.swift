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
                // Main Branch (Thicker, more prominent)
                Path { path in
                    let w = proxy.size.width
                    let h = proxy.size.height
                    path.move(to: CGPoint(x: w + 60, y: -60))
                    path.addCurve(
                        to: CGPoint(x: w * 0.35, y: h * 0.45),
                        control1: CGPoint(x: w * 0.8, y: h * 0.15),
                        control2: CGPoint(x: w * 0.5, y: h * 0.25)
                    )
                }
                .stroke(Color.black.opacity(0.25), style: StrokeStyle(lineWidth: 18, lineCap: .round))

                // Secondary Branch (Right)
                Path { path in
                    let w = proxy.size.width
                    let h = proxy.size.height
                    path.move(to: CGPoint(x: w * 0.75, y: h * 0.2))
                    path.addQuadCurve(to: CGPoint(x: w * 0.6, y: h * 0.65), control: CGPoint(x: w * 0.6, y: h * 0.4))
                }
                .stroke(Color.black.opacity(0.25), style: StrokeStyle(lineWidth: 10, lineCap: .round))

                // Tertiary Branch (Top)
                Path { path in
                    let w = proxy.size.width
                    let h = proxy.size.height
                    path.move(to: CGPoint(x: w * 0.55, y: h * 0.1))
                    path.addQuadCurve(to: CGPoint(x: w * 0.2, y: h * 0.3), control: CGPoint(x: w * 0.3, y: h * 0.1))
                }
                .stroke(Color.black.opacity(0.25), style: StrokeStyle(lineWidth: 8, lineCap: .round))

                // More Leaves for richer content
                // Group 1: Main Cluster
                LeafGroup(triggerWind: triggerWind, x: 0.35, y: 0.45, delay: 0)
                LeafGroup(triggerWind: triggerWind, x: 0.40, y: 0.42, delay: 0.2)
                LeafGroup(triggerWind: triggerWind, x: 0.30, y: 0.48, delay: 0.4)

                // Group 2: Right Cluster
                LeafGroup(triggerWind: triggerWind, x: 0.6, y: 0.65, delay: 0.1)
                LeafGroup(triggerWind: triggerWind, x: 0.65, y: 0.60, delay: 0.3)

                // Group 3: Top Cluster
                LeafGroup(triggerWind: triggerWind, x: 0.2, y: 0.3, delay: 0.5)
                LeafGroup(triggerWind: triggerWind, x: 0.25, y: 0.25, delay: 0.7)

                // Scattered Leaves
                LeafGroup(triggerWind: triggerWind, x: 0.8, y: 0.3, delay: 0.2)
                LeafGroup(triggerWind: triggerWind, x: 0.5, y: 0.2, delay: 0.6)
            }
        }
        .allowsHitTesting(false)
    }
}

struct LeafGroup: View {
    var triggerWind: Bool
    var x: CGFloat
    var y: CGFloat
    var delay: Double
    @State private var sway: Double = 0.0

    var body: some View {
        GeometryReader { proxy in
            Image(systemName: "leaf.fill")
                .font(.system(size: 22)) // Slightly smaller for subtlety
                .foregroundColor(Color.black.opacity(0.35)) // More subtle opacity
                .rotationEffect(.degrees(sway))
                .position(x: proxy.size.width * x, y: proxy.size.height * y)
                .onChange(of: triggerWind) { _ in
                    // Wind gust: faster but limited range
                    withAnimation(.easeInOut(duration: 0.4).repeatCount(2, autoreverses: true).delay(delay)) {
                        sway = Double.random(in: -15...15)
                    }
                    // Return to slow sway
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        startGentleSway()
                    }
                }
                .onAppear {
                    startGentleSway()
                }
        }
    }

    func startGentleSway() {
        // Very slow, subtle movement
        withAnimation(.easeInOut(duration: Double.random(in: 4.0...6.0)).repeatForever(autoreverses: true)) {
            sway = Double.random(in: -5...5)
        }
    }
}

// MARK: - Mood Setter Component
struct MoodSetterSmall: View {
    @Binding var selectedMood: Mood
    @Binding var triggerEffect: Bool

    var body: some View {
        HStack(spacing: 15) {
            ForEach(Mood.allCases) { mood in
                Button(action: {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        selectedMood = mood
                    }
                    triggerEffect.toggle() // Trigger animation effect
                }) {
                    Text(mood.emoji)
                        .font(.title2)
                        .grayscale(selectedMood == mood ? 0 : 1)
                        .opacity(selectedMood == mood ? 1 : 0.4)
                        .scaleEffect(selectedMood == mood ? 1.2 : 1.0)
                        .padding(10)
                        .background(selectedMood == mood ? Color.white.opacity(0.15) : Color.clear)
                        .clipShape(Circle())
                }
            }
        }
        .padding(6)
        .background(Color.black.opacity(0.3))
        .cornerRadius(35)
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

    @State private var triggerEffect = false

    var body: some View {
        ZStack {
            // 1. Base Gradient Layer (Changes based on mood)
            Group {
                LinearGradient(
                    colors: themeViewModel.selectedMood.gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 1.0), value: themeViewModel.selectedMood)

            // 2. Animated Overlay Layer (Switches with fade transition)
            ZStack {
                switch themeViewModel.selectedMood {
                case .calm:
                    AnimatedTreeView(triggerWind: $triggerEffect)
                case .cozy:
                    CozyWarmBackground()
                case .sad:
                    RainRiverBackground(triggerEffect: $triggerEffect)
                case .energetic:
                    EnergeticSparklesBackground()
                case .happy:
                    HappyBubblesBackground()
                case .nervous:
                    NervousPulseBackground()
                }
            }
            .transition(.opacity)
            .animation(.easeInOut(duration: 1.0), value: themeViewModel.selectedMood)
            .id(themeViewModel.selectedMood) // Force redraw on change to trigger transition

            VStack(spacing: 0) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("My plan")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(formattedDate)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.6))

                            // Wellness Points
                            HStack(spacing: 6) {
                                Image(systemName: "leaf.circle.fill")
                                    .foregroundColor(Color(hex: "7D5FFF"))
                                    .font(.system(size: 14))
                                Text("\(viewModel.totalPoints) Wellness Points")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 10)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(20)
                        }

                        // Mood Setter
                        MoodSetterSmall(selectedMood: $themeViewModel.selectedMood, triggerEffect: $triggerEffect)
                            .padding(.top, 12)
                    }

                    Spacer()

                    // Stats Circle
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 4)
                            .frame(width: 60, height: 60)

                        Circle()
                            .trim(from: 0, to: viewModel.progressPercentage)
                            .stroke(
                                AngularGradient(
                                    colors: [
                                        Color.white.opacity(0.8),
                                        Color.white.opacity(0.5),
                                        Color.white.opacity(0.8)
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
                                .foregroundStyle(.white)
                            Text("%")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.white.opacity(0.7))
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
