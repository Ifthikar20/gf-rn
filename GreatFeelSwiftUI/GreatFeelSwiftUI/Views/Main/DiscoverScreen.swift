//
//  DiscoverScreen.swift
//  GreatFeelSwiftUI
//
//  Discover screen with trending content
//

import SwiftUI

struct DiscoverScreen: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = LibraryViewModel()
    @Environment(\.colorScheme) var colorScheme

    @State private var selectedType: ContentType?

    var body: some View {
        NavigationStack {
            ThemedBackground(opacity: 0.85) {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.xl) {
                        // Header with Avatar and Filters
                        header

                        // Popular Wellness
                        popularWellness

                        // Trending Content
                        trendingContent

                        Spacer(minLength: AppSpacing.xl)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadContent()
        }
    }

    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            // Avatar and Title
            HStack {
                AsyncImage(url: URL(string: authViewModel.user?.avatar ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .empty, .failure, _:
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .foregroundColor(AppColors.primary(for: colorScheme))
                    }
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())

                Text("Discover")
                    .font(AppTypography.heading3())
                    .foregroundColor(AppColors.textPrimary(for: colorScheme))

                Spacer()
            }

            // Type Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.sm) {
                    typeFilterPill(title: "All", type: nil)

                    ForEach(ContentType.allCases, id: \.self) { type in
                        typeFilterPill(title: type.rawValue, type: type)
                    }
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.md)
    }

    private func typeFilterPill(title: String, type: ContentType?) -> some View {
        Button(action: { selectedType = type }) {
            Text(title)
                .font(AppTypography.smallMedium())
                .foregroundColor(selectedType == type ? .white : AppColors.textPrimary(for: colorScheme))
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
                .background(selectedType == type ? AppColors.primary(for: colorScheme) : AppColors.surface(for: colorScheme))
                .cornerRadius(AppSpacing.Radius.full)
        }
    }

    // MARK: - Popular Wellness
    private var popularWellness: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Popular Wellness")
                .font(AppTypography.heading5())
                .foregroundColor(AppColors.textPrimary(for: colorScheme))
                .padding(.horizontal, AppSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(filteredContent.prefix(6)) { item in
                        popularCard(item: item)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
    }

    private func popularCard(item: ContentItem) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            // Thumbnail
            AsyncImage(url: URL(string: item.thumbnail ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .empty, .failure, _:
                    AppColors.Category.mindfulness.opacity(0.3)
                }
            }
            .frame(width: 200, height: 120)
            .cornerRadius(AppSpacing.Radius.lg)

            // Title
            Text(item.title)
                .font(AppTypography.bodyMedium())
                .foregroundColor(AppColors.textPrimary(for: colorScheme))
                .lineLimit(2)
                .frame(width: 200, alignment: .leading)

            // Category
            Text(item.category.displayName)
                .font(AppTypography.caption())
                .foregroundColor(AppColors.textSecondary(for: colorScheme))
        }
        .padding(AppSpacing.sm)
        .background(AppColors.surface(for: colorScheme).opacity(0.5))
        .cornerRadius(AppSpacing.Radius.lg)
        .cardShadow()
    }

    // MARK: - Trending Content
    private var trendingContent: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Trending Now")
                .font(AppTypography.heading5())
                .foregroundColor(AppColors.textPrimary(for: colorScheme))
                .padding(.horizontal, AppSpacing.md)

            VStack(spacing: AppSpacing.md) {
                ForEach(filteredContent.prefix(5)) { item in
                    trendingRow(item: item)
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
    }

    private func trendingRow(item: ContentItem) -> some View {
        HStack(spacing: AppSpacing.md) {
            // Thumbnail
            AsyncImage(url: URL(string: item.thumbnail ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .empty, .failure, _:
                    AppColors.surface(for: colorScheme)
                }
            }
            .frame(width: 80, height: 80)
            .cornerRadius(AppSpacing.Radius.md)

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(AppTypography.bodyMedium())
                    .foregroundColor(AppColors.textPrimary(for: colorScheme))
                    .lineLimit(2)

                Text(item.category.displayName)
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))

                if let viewCount = item.viewCount {
                    HStack(spacing: 4) {
                        Image(systemName: "eye")
                            .font(.system(size: AppSpacing.IconSize.xs))
                        Text("\(viewCount) views")
                            .font(AppTypography.caption())
                    }
                    .foregroundColor(AppColors.textTertiary(for: colorScheme))
                }
            }

            Spacer()
        }
        .padding(AppSpacing.sm)
        .background(AppColors.surface(for: colorScheme).opacity(0.5))
        .cornerRadius(AppSpacing.Radius.lg)
    }

    private var filteredContent: [ContentItem] {
        if let type = selectedType {
            return viewModel.content(ofType: type)
        }
        return viewModel.content
    }
}

// MARK: - Preview
#Preview {
    DiscoverScreen()
        .environmentObject(ThemeViewModel())
        .environmentObject(AuthViewModel())
}
