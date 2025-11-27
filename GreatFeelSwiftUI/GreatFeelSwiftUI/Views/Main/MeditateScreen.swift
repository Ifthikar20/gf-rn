//
//  MeditateScreen.swift
//  GreatFeelSwiftUI
//
//  Modern relaxation screen with animated tree background
//

import SwiftUI

struct MeditateScreen: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @StateObject private var viewModel = MeditationViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var triggerTreeWind = false
    @State private var selectedSession: MeditationSession?
    @State private var showPlayer = false

    var body: some View {
        NavigationStack {
            ZStack {
            // Background Gradient
            LinearGradient(
                colors: colorScheme == .dark
                    ? [AppColors.Dark.deepNightStart, AppColors.Dark.deepNightEnd]
                    : [Color(hex: "EEF2FF"), Color(hex: "E0E7FF")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Animated Tree Overlay (only in dark mode)
            if colorScheme == .dark {
                AnimatedTreeView(triggerWind: $triggerTreeWind)
                    .ignoresSafeArea()
            }

            // Main Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Header with greeting and stats
                    headerView
                        .padding(.top, 10)

                    // Daily Inspiration Card
                    inspirationCard

                    // Featured Sessions
                    if !viewModel.featuredSessions.isEmpty {
                        modernSessionSection(
                            title: "Featured Today",
                            icon: "star.fill",
                            sessions: viewModel.featuredSessions
                        )
                    }

                    // Categories Grid
                    categoriesGrid

                    // Popular This Week
                    if !viewModel.popularSessions.isEmpty {
                        modernSessionSection(
                            title: "Popular This Week",
                            icon: "chart.line.uptrend.xyaxis",
                            sessions: viewModel.popularSessions
                        )
                    }

                    // Editor's Picks
                    if !viewModel.editorsPickSessions.isEmpty {
                        modernSessionSection(
                            title: "Editor's Picks",
                            icon: "hand.thumbsup.fill",
                            sessions: viewModel.editorsPickSessions
                        )
                    }

                    Spacer(minLength: 60)
                }
                .padding(.horizontal)
            }
            }
        }
        .fullScreenCover(isPresented: $showPlayer) {
            if let session = selectedSession {
                MediaPlayerScreen(session: session)
            }
        }
        .onAppear {
            viewModel.loadSessions()
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(greetingText())
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                    .textCase(.uppercase)
                    .kerning(0.5)

                Text("Ready to Relax?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)
            }

            Spacer()

            // Streak indicator with progress
            ZStack {
                Circle()
                    .stroke(
                        colorScheme == .dark
                            ? Color.white.opacity(0.1)
                            : Color.black.opacity(0.05),
                        lineWidth: 4
                    )
                    .frame(width: 56, height: 56)

                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        AngularGradient(
                            colors: [AppColors.primary(for: colorScheme), AppColors.secondary(for: colorScheme)],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 56, height: 56)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 0) {
                    Text("7")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(AppColors.primary(for: colorScheme))
                    Text("days")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                }
            }
        }
    }

    // MARK: - Inspiration Card
    private var inspirationCard: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("7 Day Streak!")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                }

                Text("Amazing! Keep your streak going with a morning meditation.")
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Image(systemName: "trophy.fill")
                .font(.system(size: 40))
                .foregroundStyle(.yellow)
                .shadow(color: .yellow.opacity(0.5), radius: 10)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [
                    AppColors.primary(for: colorScheme),
                    AppColors.secondary(for: colorScheme)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: AppColors.primary(for: colorScheme).opacity(0.3), radius: 15, y: 8)
    }

    // MARK: - Categories Grid
    private var categoriesGrid: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "square.grid.2x2.fill")
                    .foregroundStyle(AppColors.primary(for: colorScheme))
                Text("Browse by Category")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                CategoryCard(
                    title: "Meditation",
                    icon: "figure.mind.and.body",
                    color: AppColors.Category.meditation,
                    colorScheme: colorScheme
                )
                CategoryCard(
                    title: "Sleep",
                    icon: "moon.stars.fill",
                    color: AppColors.Category.sleep,
                    colorScheme: colorScheme
                )
                CategoryCard(
                    title: "Breathing",
                    icon: "wind",
                    color: AppColors.Category.breath,
                    colorScheme: colorScheme
                )
                CategoryCard(
                    title: "Relax",
                    icon: "music.note",
                    color: AppColors.Category.relax,
                    colorScheme: colorScheme
                )
            }
        }
    }

    // MARK: - Modern Session Section
    private func modernSessionSection(title: String, icon: String, sessions: [MeditationSession]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(AppColors.primary(for: colorScheme))
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(sessions) { session in
                        ModernSessionCard(session: session, colorScheme: colorScheme) {
                            print("🎵 Card tapped: \(session.title)")
                            selectedSession = session
                            showPlayer = true
                            triggerTreeWind.toggle()
                            print("🎵 showPlayer set to: \(showPlayer)")
                            print("🎵 selectedSession: \(selectedSession?.title ?? "nil")")
                        }
                    }
                }
            }
        }
    }

    // Helper function for greeting
    private func greetingText() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        default: return "Good Evening"
        }
    }
}

// MARK: - Category Card Component
struct CategoryCard: View {
    let title: String
    let icon: String
    let color: Color
    let colorScheme: ColorScheme

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundStyle(color)
                }

                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textTertiary : AppColors.Light.textTertiary)
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
                        colorScheme == .dark
                            ? Color.white.opacity(0.05)
                            : Color.black.opacity(0.03),
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
    }
}

// MARK: - Modern Session Card
struct ModernSessionCard: View {
    let session: MeditationSession
    let colorScheme: ColorScheme
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // Cover Image with Play Button Overlay
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: session.coverImage ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .empty, .failure, _:
                            LinearGradient(
                                colors: [
                                    AppColors.primary(for: colorScheme).opacity(0.6),
                                    AppColors.secondary(for: colorScheme).opacity(0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        }
                    }
                    .frame(width: 180, height: 180)
                    .cornerRadius(16)
                    .overlay(
                        LinearGradient(
                            colors: [Color.clear, Color.black.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .cornerRadius(16)
                    )

                    // Play Button
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 40, height: 40)

                        Image(systemName: "play.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                    .padding(10)
                }

                // Title
                Text(session.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textPrimary : AppColors.Light.textPrimary)
                    .lineLimit(2)
                    .frame(width: 180, alignment: .leading)

                // Duration & Category
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                    Text("\(session.duration) min")
                        .font(.system(size: 13, weight: .medium))

                    Text("•")
                    Text(session.category.rawValue)
                        .font(.system(size: 13))
                }
                .foregroundStyle(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview
#Preview {
    MeditateScreen()
        .environmentObject(ThemeViewModel())
        .preferredColorScheme(.dark)
}
