//
//  GoalsScreen.swift
//  GreatFeelSwiftUI
//
//  Goals screen with time-based sections
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

    var body: some View {
        ThemedBackground(opacity: 0.85) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    // Header
                    header

                    // Welcome Message
                    welcomeCard

                    // Morning Goals
                    if !viewModel.morningGoals.isEmpty {
                        goalSection(
                            title: "Morning",
                            icon: TimeOfDay.morning.emoji,
                            goals: viewModel.morningGoals
                        )
                    }

                    // Day Goals
                    if !viewModel.dayGoals.isEmpty {
                        goalSection(
                            title: "Day",
                            icon: TimeOfDay.day.emoji,
                            goals: viewModel.dayGoals
                        )
                    }

                    // Evening Goals
                    if !viewModel.eveningGoals.isEmpty {
                        goalSection(
                            title: "Evening",
                            icon: TimeOfDay.evening.emoji,
                            goals: viewModel.eveningGoals
                        )
                    }

                    Spacer(minLength: AppSpacing.xl)
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
        .onAppear {
            viewModel.loadGoals()
        }
    }

    // MARK: - Header
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(formattedDate)
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))

                Text("My Goals")
                    .font(AppTypography.heading3())
                    .foregroundColor(AppColors.textPrimary(for: colorScheme))
            }

            Spacer()

            // Progress Circle
            ZStack {
                Circle()
                    .stroke(AppColors.border(for: colorScheme), lineWidth: 3)
                    .frame(width: 50, height: 50)

                Circle()
                    .trim(from: 0, to: viewModel.progressPercentage)
                    .stroke(AppColors.primary(for: colorScheme), lineWidth: 3)
                    .frame(width: 50, height: 50)
                    .rotationEffect(.degrees(-90))

                Text("\(Int(viewModel.progressPercentage * 100))%")
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.textPrimary(for: colorScheme))
            }
        }
        .padding(.top, AppSpacing.md)
    }

    // MARK: - Welcome Card
    private var welcomeCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Welcome aboard! 🎉")
                .font(AppTypography.heading6())
                .foregroundColor(AppColors.textPrimary(for: colorScheme))

            Text("Start your wellness journey by completing daily goals")
                .font(AppTypography.small())
                .foregroundColor(AppColors.textSecondary(for: colorScheme))
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.primary(for: colorScheme).opacity(0.1))
        .cornerRadius(AppSpacing.Radius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: AppSpacing.Radius.lg)
                .stroke(AppColors.primary(for: colorScheme).opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Goal Section
    private func goalSection(title: String, icon: String, goals: [Goal]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.xs) {
                Text(icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(AppTypography.heading5())
                    .foregroundColor(AppColors.textPrimary(for: colorScheme))
            }

            LazyVGrid(columns: columns, spacing: AppSpacing.md) {
                ForEach(goals) { goal in
                    GoalCard(
                        goal: goal,
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

// MARK: - Preview
#Preview {
    GoalsScreen()
        .environmentObject(ThemeViewModel())
}
