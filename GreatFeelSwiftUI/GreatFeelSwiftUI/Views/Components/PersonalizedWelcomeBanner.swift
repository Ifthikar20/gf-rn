//
//  PersonalizedWelcomeBanner.swift
//  GreatFeelSwiftUI
//
//  Created by Claude Code
//  Sample component showing how to use PersonalizationService
//

import SwiftUI

struct PersonalizedWelcomeBanner: View {
    private let personalization = PersonalizationService.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Personalized welcome message
            Text(personalization.getWelcomeMessage())
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "#1F2937"))

            // Daily tip
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "#F59E0B"))

                Text(personalization.getDailyTip())
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#6B7280"))
            }

            // Recommended session duration
            if personalization.hasCompletedOnboarding() {
                HStack(spacing: 8) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#6366F1"))

                    Text("Recommended: \(personalization.getRecommendedSessionDuration()) min sessions")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#4B5563"))
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
        .padding(.horizontal, 20)
    }
}

// MARK: - Example Usage in Main Screen
struct PersonalizedHomeExample: View {
    private let personalization = PersonalizationService.shared

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Welcome Banner
                PersonalizedWelcomeBanner()

                // Show onboarding summary for debugging/testing
                if let summary = personalization.getOnboardingSummary() {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Profile")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal, 20)

                        Text(summary.description)
                            .font(.system(size: 14, design: .monospaced))
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(hex: "#F3F4F6"))
                            )
                            .padding(.horizontal, 20)
                    }
                }

                // Recommended categories
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recommended for You")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.horizontal, 20)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(personalization.getRecommendedCategories().prefix(6), id: \.self) { category in
                                CategoryChip(title: category)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }

                Spacer()
            }
            .padding(.vertical, 20)
        }
        .background(Color(hex: "#F9FAFB"))
    }
}

// MARK: - Category Chip Component
struct CategoryChip: View {
    let title: String

    var body: some View {
        Text(title.capitalized)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
    }
}

#Preview {
    PersonalizedHomeExample()
}
