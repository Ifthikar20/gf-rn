//
//  LibraryScreen.swift
//  GreatFeelSwiftUI
//
//  Library screen showing saved/bookmarked content only
//

import SwiftUI

struct LibraryScreen: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @StateObject private var viewModel = LibraryViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var triggerEffect = false

    var body: some View {
        NavigationStack {
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
                        ZStack {
                            StarfieldEffect()
                            AuroraEffect()
                            AnimatedTreeView(triggerWind: $triggerEffect)
                            MagicalOrbsEffect()
                            FirefliesEnhancedEffect()
                            ShootingStarsEffect()
                        }
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
                .id(themeViewModel.selectedMood)

                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.xl) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Library")
                                .font(.system(size: 34, weight: .bold))
                                .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)

                            Text("Your saved content")
                                .font(AppTypography.small())
                                .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.top, AppSpacing.md)

                        // Check if there's any bookmarked content
                        if viewModel.bookmarkedContent.isEmpty {
                            // Empty State
                            emptyStateView
                        } else {
                            // Category Filter
                            categoryFilter

                            // Bookmarked Content by Category
                            ForEach(ContentCategory.allCases, id: \.self) { category in
                                let items = filteredBookmarkedContent.filter { $0.category == category }
                                if !items.isEmpty {
                                    contentSection(title: category.displayName, items: items)
                                }
                            }
                        }

                        Spacer(minLength: AppSpacing.xl)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadContent()
        }
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "bookmark.slash.fill")
                .font(.system(size: 60))
                .foregroundColor(colorScheme == .dark ? AppColors.Dark.textTertiary : AppColors.Light.textTertiary)

            Text("No Saved Content")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)

            Text("Save content from Discover to access it here")
                .font(.body)
                .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
    }

    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                // All categories
                categoryPill(title: "All", isSelected: viewModel.selectedCategory == nil) {
                    viewModel.selectCategory(nil)
                }

                // Individual categories (only show categories that have bookmarked content)
                ForEach(ContentCategory.allCases, id: \.self) { category in
                    let hasContent = viewModel.bookmarkedContent.contains { $0.category == category }
                    if hasContent {
                        categoryPill(
                            title: category.displayName,
                            isSelected: viewModel.selectedCategory == category
                        ) {
                            viewModel.selectCategory(category)
                        }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
    }

    private func categoryPill(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.smallMedium())
                .foregroundColor(isSelected ? .white : (colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary))
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
                .background(
                    isSelected
                        ? AppColors.primary(for: colorScheme)
                        : (colorScheme == .dark ? AppColors.Dark.discoverSurface : Color.white)
                )
                .cornerRadius(AppSpacing.Radius.full)
        }
    }

    // MARK: - Content Section
    private func contentSection(title: String, items: [ContentItem]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text(title)
                    .font(AppTypography.heading6())
                    .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)

                Text("(\(items.count))")
                    .font(AppTypography.caption())
                    .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)

                Spacer()
            }
            .padding(.horizontal, AppSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(items) { item in
                        savedContentCard(item: item)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
    }

    private func savedContentCard(item: ContentItem) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            // Thumbnail
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: item.thumbnail ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .empty, .failure, _:
                        Rectangle()
                            .fill(categoryColor(for: item.category).opacity(0.3))
                            .overlay(
                                Image(systemName: iconForCategory(item.category))
                                    .font(.system(size: 30))
                                    .foregroundColor(categoryColor(for: item.category))
                            )
                    }
                }
                .frame(width: 130, height: 173)
                .cornerRadius(AppSpacing.Radius.md)

                // Bookmark button to unsave
                Button(action: {
                    viewModel.toggleBookmark(item.id)
                }) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(AppColors.primary(for: colorScheme))
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(8)
            }
            .overlay(
                // Type badge
                VStack {
                    HStack {
                        Spacer()
                    }
                    Spacer()
                    HStack {
                        Text(item.type.rawValue)
                            .font(AppTypography.caption())
                            .foregroundColor(.white)
                            .padding(.horizontal, AppSpacing.xs)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(AppSpacing.Radius.sm)
                            .padding(AppSpacing.xs)
                        Spacer()
                    }
                }
            )

            // Title
            Text(item.title)
                .font(AppTypography.caption())
                .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                .lineLimit(2)
                .frame(width: 130, alignment: .leading)

            // Duration
            if let duration = item.duration {
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 10))
                    Text("\(duration) min")
                        .font(.system(size: 11))
                }
                .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
            }
        }
    }

    // MARK: - Helper Functions
    private var filteredBookmarkedContent: [ContentItem] {
        guard let category = viewModel.selectedCategory else {
            return viewModel.bookmarkedContent
        }
        return viewModel.bookmarkedContent.filter { $0.category == category }
    }

    private func categoryColor(for category: ContentCategory) -> Color {
        switch category {
        case .mindfulness: return AppColors.Category.mindfulness
        case .stress: return AppColors.Category.stress
        case .sleep: return AppColors.Category.sleep
        case .anxiety: return AppColors.Category.anxiety
        case .meditation: return AppColors.Category.meditation
        default: return AppColors.primary(for: colorScheme)
        }
    }

    private func iconForCategory(_ category: ContentCategory) -> String {
        switch category {
        case .mindfulness: return "sparkles"
        case .stress: return "exclamationmark.triangle.fill"
        case .sleep: return "moon.stars.fill"
        case .anxiety: return "heart.fill"
        case .meditation: return "figure.mind.and.body"
        case .productivity: return "target"
        default: return "star.fill"
        }
    }
}

// MARK: - Preview
#Preview {
    LibraryScreen()
        .environmentObject(ThemeViewModel())
}
