//
//  GoalsScreen.swift
//  GreatFeelSwiftUI
//
//  Modern Goals screen with vibrant design and dark mode
//

import SwiftUI

struct GoalsScreen: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @StateObject private var viewModel = GoalsViewModel()
    @Environment(\.colorScheme) var colorScheme

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // Dynamic vibrant gradient background
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: colorScheme == .dark
                ? [Color(hex: "0F172A"), Color(hex: "1E293B"), Color(hex: "334155")]
                : [Color(hex: "F0F9FF"), Color(hex: "E0F2FE"), Color(hex: "BAE6FD")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        ZStack {
            // Vibrant Background
            backgroundGradient
                .ignoresSafeArea()

            // Floating gradient orbs
            GeometryReader { proxy in
                Circle()
                    .fill(AppColors.primary(for: colorScheme).opacity(colorScheme == .dark ? 0.12 : 0.15))
                    .frame(width: 280, height: 280)
                    .blur(radius: 50)
                    .offset(x: -80, y: -40)

                Circle()
                    .fill(AppColors.Category.breath.opacity(colorScheme == .dark ? 0.12 : 0.15))
                    .frame(width: 240, height: 240)
                    .blur(radius: 50)
                    .offset(x: proxy.size.width - 120, y: proxy.size.height - 180)
            }

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    modernHeader

                    // Stats Overview Card
                    statsCard

                    // Morning Goals
                    if !viewModel.morningGoals.isEmpty {
                        modernGoalSection(
                            title: "Morning",
                            icon: "sunrise.fill",
                            iconColor: .orange,
                            goals: viewModel.morningGoals
                        )
                    }

                    // Day Goals
                    if !viewModel.dayGoals.isEmpty {
                        modernGoalSection(
                            title: "Day",
                            icon: "sun.max.fill",
                            iconColor: .yellow,
                            goals: viewModel.dayGoals
                        )
                    }

                    // Evening Goals
                    if !viewModel.eveningGoals.isEmpty {
                        modernGoalSection(
                            title: "Evening",
                            icon: "moon.stars.fill",
                            iconColor: AppColors.Category.sleep,
                            goals: viewModel.eveningGoals
                        )
                    }

                    Spacer(minLength: 60)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            viewModel.loadGoals()
        }
    }

    // MARK: - Modern Header
    private var modernHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate.uppercased())
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                    .kerning(0.5)

                Text("My Goals")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)
            }

            Spacer()

            // Enhanced Progress Circle
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
        .padding(.top, 10)
    }

    // MARK: - Stats Card
    private var statsCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Completed Today
                StatItem(
                    icon: "checkmark.circle.fill",
                    value: "\(viewModel.completedCount)",
                    label: "Completed",
                    color: AppColors.Category.relax,
                    colorScheme: colorScheme
                )

                Divider()
                    .frame(height: 40)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05))

                // Streak
                StatItem(
                    icon: "flame.fill",
                    value: "7",
                    label: "Day Streak",
                    color: .orange,
                    colorScheme: colorScheme
                )

                Divider()
                    .frame(height: 40)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05))

                // Total
                StatItem(
                    icon: "target",
                    value: "\(viewModel.totalCount)",
                    label: "Total Goals",
                    color: AppColors.primary(for: colorScheme),
                    colorScheme: colorScheme
                )
            }
            .padding(20)
        }
        .background(.ultraThinMaterial)
        .background(
            colorScheme == .dark
                ? AppColors.Dark.surface.opacity(0.5)
                : AppColors.Light.surface.opacity(0.9)
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    colorScheme == .dark
                        ? Color.white.opacity(0.08)
                        : Color.black.opacity(0.03),
                    lineWidth: 1
                )
        )
        .shadow(
            color: colorScheme == .dark
                ? Color.black.opacity(0.3)
                : Color.black.opacity(0.08),
            radius: 12,
            y: 6
        )
    }

    // MARK: - Modern Goal Section
    private func modernGoalSection(title: String, icon: String, iconColor: Color, goals: [Goal]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(iconColor)
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)
            }

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(goals) { goal in
                    ModernGoalCard(
                        goal: goal,
                        colorScheme: colorScheme,
                        onTap: {
                            // Navigate to goal detail
                        },
                        onToggleComplete: {
                            viewModel.toggleGoalCompletion(goal.id)
                        }
                    )
                }
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
}

// MARK: - Stat Item Component
struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    let colorScheme: ColorScheme

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(color)
            }

            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)

            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Modern Goal Card
struct ModernGoalCard: View {
    let goal: Goal
    let colorScheme: ColorScheme
    let onTap: () -> Void
    let onToggleComplete: () -> Void

    // Helper computed properties to break up complex expressions
    private var completionCircleColor: Color {
        if goal.isCompleted {
            return AppColors.Category.relax
        } else {
            return colorScheme == .dark
                ? Color.white.opacity(0.05)
                : Color.black.opacity(0.03)
        }
    }

    private var strokeColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.2)
            : Color.black.opacity(0.1)
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    // Icon
                    iconView

                    Spacer()

                    // Completion Button
                    completionButton
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(goal.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)
                        .lineLimit(2)

                    HStack(spacing: 6) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 11))
                        Text("\(goal.targetDuration) min")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                }
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .background(
                colorScheme == .dark
                    ? AppColors.Dark.surface.opacity(0.6)
                    : AppColors.Light.surface.opacity(0.8)
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        goal.isCompleted
                            ? AppColors.Category.relax.opacity(0.3)
                            : (colorScheme == .dark
                                ? Color.white.opacity(0.05)
                                : Color.black.opacity(0.03)),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: colorScheme == .dark
                    ? Color.black.opacity(0.3)
                    : Color.black.opacity(0.05),
                radius: 8,
                y: 4
            )
        }
        .buttonStyle(.plain)
    }

    // Helper views to break up complex expressions
    private var iconView: some View {
        ZStack {
            Circle()
                .fill(goal.category.color.opacity(0.15))
                .frame(width: 44, height: 44)

            Image(systemName: goal.category.icon)
                .font(.system(size: 20))
                .foregroundStyle(goal.category.color)
        }
    }

    private var completionButton: some View {
        Button(action: onToggleComplete) {
            ZStack {
                Circle()
                    .fill(completionCircleColor)
                    .frame(width: 28, height: 28)

                if goal.isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                } else {
                    Circle()
                        .stroke(strokeColor, lineWidth: 2)
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    GoalsScreen()
        .environmentObject(ThemeViewModel())
        .preferredColorScheme(.dark)
}
