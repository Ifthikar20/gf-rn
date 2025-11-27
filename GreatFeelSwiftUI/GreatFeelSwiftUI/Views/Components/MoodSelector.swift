//
//  MoodSelector.swift
//  GreatFeelSwiftUI
//
//  Mood selector component
//

import SwiftUI

struct MoodSelector: View {
    @Binding var selectedMood: Mood

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.md) {
                ForEach(Mood.allCases) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: mood == selectedMood,
                        action: { selectedMood = mood }
                    )
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
    }
}

// MARK: - Mood Button
struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action) {
            VStack(spacing: AppSpacing.xs) {
                // Emoji
                Text(mood.emoji)
                    .font(.system(size: 32))
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(isSelected ? AppColors.primary(for: colorScheme).opacity(0.1) : AppColors.surface(for: colorScheme))
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                isSelected ? AppColors.primary(for: colorScheme) : Color.clear,
                                lineWidth: 2
                            )
                    )

                // Name
                Text(mood.rawValue)
                    .font(AppTypography.caption())
                    .foregroundColor(
                        isSelected ? AppColors.primary(for: colorScheme) : AppColors.textSecondary(for: colorScheme)
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    VStack {
        MoodSelector(selectedMood: .constant(.happy))
            .padding()

        Divider()

        HStack {
            ForEach(Mood.allCases) { mood in
                MoodButton(mood: mood, isSelected: mood == .calm, action: {})
            }
        }
        .padding()
    }
}
