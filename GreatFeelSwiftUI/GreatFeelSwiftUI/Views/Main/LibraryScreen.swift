//
//  LibraryScreen.swift
//  GreatFeelSwiftUI
//
//  Library screen with content filtering
//

import SwiftUI

struct LibraryScreen: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @StateObject private var viewModel = LibraryViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            ThemedBackground(opacity: 0.85) {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.xl) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Library")
                                .font(AppTypography.heading3())
                                .foregroundColor(AppColors.textPrimary(for: colorScheme))

                            Text("Explore wellness content")
                                .font(AppTypography.small())
                                .foregroundColor(AppColors.textSecondary(for: colorScheme))
                        }
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.top, AppSpacing.md)

                        // Category Filter
                        categoryFilter

                        // Content by Category
                        ForEach(ContentCategory.allCases, id: \.self) { category in
                            let items = viewModel.content(for: category)
                            if !items.isEmpty {
                                contentSection(title: category.displayName, items: items)
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

    // MARK: - Category Filter
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                // All categories
                categoryPill(title: "All", isSelected: viewModel.selectedCategory == nil) {
                    viewModel.selectCategory(nil)
                }

                // Individual categories
                ForEach(ContentCategory.allCases, id: \.self) { category in
                    categoryPill(
                        title: category.displayName,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        viewModel.selectCategory(category)
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
                .foregroundColor(isSelected ? .white : AppColors.textPrimary(for: colorScheme))
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
                .background(isSelected ? AppColors.primary(for: colorScheme) : AppColors.surface(for: colorScheme))
                .cornerRadius(AppSpacing.Radius.full)
        }
    }

    // MARK: - Content Section
    private func contentSection(title: String, items: [ContentItem]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .font(AppTypography.heading6())
                .foregroundColor(AppColors.textPrimary(for: colorScheme))
                .padding(.horizontal, AppSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(items) { item in
                        contentCard(item: item)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
            }
        }
    }

    private func contentCard(item: ContentItem) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
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
            .frame(width: 130, height: 173)
            .cornerRadius(AppSpacing.Radius.md)
            .overlay(
                // Type badge
                VStack {
                    HStack {
                        Spacer()
                        Text(item.type.rawValue)
                            .font(AppTypography.caption())
                            .foregroundColor(.white)
                            .padding(.horizontal, AppSpacing.xs)
                            .padding(.vertical: 2)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(AppSpacing.Radius.sm)
                            .padding(AppSpacing.xs)
                    }
                    Spacer()
                }
            )

            // Title
            Text(item.title)
                .font(AppTypography.caption())
                .foregroundColor(AppColors.textPrimary(for: colorScheme))
                .lineLimit(2)
                .frame(width: 130, alignment: .leading)
        }
    }
}

// MARK: - Preview
#Preview {
    LibraryScreen()
        .environmentObject(ThemeViewModel())
}
