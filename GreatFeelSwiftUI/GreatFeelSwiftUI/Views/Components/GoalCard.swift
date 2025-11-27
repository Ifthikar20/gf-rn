//
//  GoalCard.swift
//  GreatFeelSwiftUI
//
//  Goal card component for Goals screen
//

import SwiftUI

struct GoalCard: View {
    let goal: Goal
    let onTap: () -> Void
    let onToggleComplete: () -> Void

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Header with icon and lock
                HStack {
                    // Category Icon
                    ZStack {
                        Circle()
                            .fill(categoryColor.opacity(0.2))
                            .frame(width: 40, height: 40)

                        Image(systemName: goal.type.icon)
                            .font(.system(size: AppSpacing.IconSize.md))
                            .foregroundColor(categoryColor)
                    }

                    Spacer()

                    // Lock Icon
                    if goal.isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: AppSpacing.IconSize.sm))
                            .foregroundColor(AppColors.textTertiary(for: colorScheme))
                    }

                    // Completion Checkbox
                    Button(action: onToggleComplete) {
                        Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: AppSpacing.IconSize.lg))
                            .foregroundColor(goal.isCompleted ? AppColors.Light.success : AppColors.textTertiary(for: colorScheme))
                    }
                }

                // Title
                Text(goal.title)
                    .font(AppTypography.bodyMedium())
                    .foregroundColor(AppColors.textPrimary(for: colorScheme))
                    .lineLimit(2)
                    .frame(height: 40, alignment: .topLeading)

                // Duration and Type
                HStack {
                    // Duration
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: AppSpacing.IconSize.xs))
                        Text("\(goal.duration) min")
                            .font(AppTypography.caption())
                    }
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))

                    Spacer()

                    // Type Badge
                    Text(goal.type.rawValue)
                        .font(AppTypography.caption())
                        .foregroundColor(categoryColor)
                        .padding(.horizontal, AppSpacing.xs)
                        .padding(.vertical, 2)
                        .background(categoryColor.opacity(0.1))
                        .cornerRadius(AppSpacing.Radius.sm)
                }

                // Streak (if available)
                if let streak = goal.streak {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: AppSpacing.IconSize.xs))
                            .foregroundColor(.orange)
                        Text("\(streak) day streak")
                            .font(AppTypography.caption())
                            .foregroundColor(AppColors.textSecondary(for: colorScheme))
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(AppColors.surface(for: colorScheme))
            .cornerRadius(AppSpacing.Radius.lg)
            .cardShadow()
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var categoryColor: Color {
        switch goal.category {
        case .breath:
            return AppColors.Category.breath
        case .meditation:
            return AppColors.Category.meditation
        case .sleep:
            return AppColors.Category.sleep
        case .relax:
            return AppColors.Category.relax
        case .mindfulness:
            return AppColors.Category.mindfulness
        case .stress:
            return AppColors.Category.stress
        case .anxiety:
            return AppColors.Category.anxiety
        case .video:
            return AppColors.Category.productivity
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: AppSpacing.md) {
        GoalCard(goal: Goal.mockGoals[0], onTap: {}, onToggleComplete: {})
        GoalCard(goal: Goal.mockGoals[3], onTap: {}, onToggleComplete: {})
    }
    .padding()
    .background(AppColors.Light.background)
}
