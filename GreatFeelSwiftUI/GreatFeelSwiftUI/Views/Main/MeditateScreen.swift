//
//  MeditateScreen.swift
//  GreatFeelSwiftUI
//
//  Meditation and relaxation screen
//

import SwiftUI

struct MeditateScreen: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @StateObject private var viewModel = MeditationViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            ThemedBackground(opacity: 0.7) {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.xl) {
                        // Hero Section
                        heroSection

                        // Featured Sessions
                        if !viewModel.featuredSessions.isEmpty {
                            sessionSection(
                                title: "Featured Sessions",
                                sessions: viewModel.featuredSessions
                            )
                        }

                        // Popular This Week
                        if !viewModel.popularSessions.isEmpty {
                            sessionSection(
                                title: "Popular This Week",
                                sessions: viewModel.popularSessions
                            )
                        }

                        // Editor's Picks
                        if !viewModel.editorsPickSessions.isEmpty {
                            sessionSection(
                                title: "Editor's Picks",
                                sessions: viewModel.editorsPickSessions
                            )
                        }

                        Spacer(minLength: AppSpacing.xl)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadSessions()
        }
    }

    // MARK: - Hero Section
    private var heroSection: some View {
        ZStack(alignment: .topLeading) {
            // Background Image
            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=600")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .empty, .failure, _:
                    AppColors.surface(for: colorScheme)
                }
            }
            .frame(height: 300)
            .clipped()

            // Gradient Overlay
            LinearGradient(
                colors: [Color.black.opacity(0.6), Color.clear],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 300)

            // Content
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Relax & Meditate")
                    .font(AppTypography.heading2())
                    .foregroundColor(.white)

                Text("Find your inner peace")
                    .font(AppTypography.body())
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(AppSpacing.xl)
        }
        .frame(height: 300)
    }

    // MARK: - Session Section
    private func sessionSection(title: String, sessions: [MeditationSession]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .font(AppTypography.heading5())
                .foregroundColor(AppColors.textPrimary(for: colorScheme))
                .padding(.horizontal, AppSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(sessions) { session in
                        sessionCard(session: session)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
    }

    private func sessionCard(session: MeditationSession) -> some View {
        Button(action: {
            // Navigate to audio player or play here
            if let audioUrl = session.audioUrl {
                viewModel.playSession(session)
            }
        }) {
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                // Cover Image
                AsyncImage(url: URL(string: session.coverImage ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .empty, .failure, _:
                        AppColors.surface(for: colorScheme)
                    }
                }
                .frame(width: 160, height: 160)
                .cornerRadius(AppSpacing.Radius.md)

                // Title
                Text(session.title)
                    .font(AppTypography.smallMedium())
                    .foregroundColor(AppColors.textPrimary(for: colorScheme))
                    .lineLimit(2)
                    .frame(width: 160, alignment: .leading)

                // Duration
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: AppSpacing.IconSize.xs))
                    Text("\(session.duration) min")
                        .font(AppTypography.caption())
                }
                .foregroundColor(AppColors.textSecondary(for: colorScheme))
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MeditateScreen()
        .environmentObject(ThemeViewModel())
}
