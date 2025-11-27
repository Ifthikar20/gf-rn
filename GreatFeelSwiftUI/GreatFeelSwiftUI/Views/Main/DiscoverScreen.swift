//
//  DiscoverScreen.swift
//  GreatFeelSwiftUI
//
//  Discover screen with trending content - Redesigned
//

import SwiftUI

struct DiscoverScreen: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = LibraryViewModel()
    @Environment(\.colorScheme) var colorScheme

    @State private var searchText = ""
    @State private var selectedFilter = "All"

    let filters = ["All", "Sleep", "Anxiety", "Focus", "Music", "Nature"]

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: colorScheme == .dark
                    ? [AppColors.Dark.discoverBackground, Color(hex: "1E1B4B")]
                    : [Color(hex: "F0F9FF"), Color(hex: "E0F2FE")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // --- Header ---
                VStack(spacing: 20) {
                    // Title with Notification Icon
                    HStack {
                        Text("Discover")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                        Spacer()

                        // Notification Icon
                        Button(action: {}) {
                            Image(systemName: "bell.badge")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)

                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(colorScheme == .dark ? AppColors.Dark.textMuted : AppColors.Light.textSecondary)
                        TextField("", text: $searchText)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Search meditations, stories...")
                                    .foregroundColor(colorScheme == .dark ? AppColors.Dark.textMuted : AppColors.Light.textSecondary)
                            }
                            .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                    }
                    .padding()
                    .background(colorScheme == .dark ? AppColors.Dark.discoverSurface : Color.white)
                    .cornerRadius(16)
                    .padding(.horizontal)

                    // Filter Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(filters, id: \.self) { filter in
                                FilterTag(
                                    text: filter,
                                    isSelected: selectedFilter == filter,
                                    colorScheme: colorScheme
                                ) {
                                    withAnimation { selectedFilter = filter }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 20)

                // --- Scrollable Content ---
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        // Hero Section (Featured)
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Featured Today")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                                .padding(.horizontal)

                            FeaturedCard(colorScheme: colorScheme)
                                .padding(.horizontal)
                        }

                        // Recommended Horizontal List
                        ContentSection(
                            title: "Recommended for you",
                            items: Array(viewModel.content.prefix(5)),
                            colorScheme: colorScheme
                        )

                        // Quick Categories Grid
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Quick Categories")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                                .padding(.horizontal)

                            CategoryGrid(colorScheme: colorScheme)
                                .padding(.horizontal)
                        }

                        // Sleep Stories
                        ContentSection(
                            title: "Sleep Stories",
                            items: Array(viewModel.content.filter { $0.category == .sleep }.prefix(5)),
                            colorScheme: colorScheme
                        )

                        // Bottom Spacer
                        Spacer().frame(height: 100)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadContent()
        }
    }
}

// MARK: - Filter Tag Component
struct FilterTag: View {
    let text: String
    let isSelected: Bool
    let colorScheme: ColorScheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(isSelected ? .white : (colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary))
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(
                    isSelected
                        ? AppColors.primary(for: colorScheme)
                        : (colorScheme == .dark ? AppColors.Dark.discoverSurface : Color.white)
                )
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(isSelected ? 0 : 0.1), lineWidth: 1)
                )
        }
    }
}

// MARK: - Featured Card
struct FeaturedCard: View {
    let colorScheme: ColorScheme

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Image Placeholder with Gradient
            LinearGradient(
                colors: [Color.purple, Color.blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white.opacity(0.1))
                    .offset(x: 100, y: -50)
            )

            // Dark Overlay
            LinearGradient(
                colors: [.black.opacity(0.6), .clear],
                startPoint: .bottom,
                endPoint: .center
            )

            // Text Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Daily Meditation")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(6)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                    Spacer()
                    Text("10 min")
                        .font(.caption)
                        .padding(6)
                        .background(.black.opacity(0.4))
                        .cornerRadius(8)
                }

                Text("Finding Inner Peace")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Start your day with clarity and calmness.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)

                HStack {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start")
                        }
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(Color.white)
                        .cornerRadius(30)
                    }

                    Button(action: {}) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.top, 8)
            }
            .padding(20)
            .foregroundColor(.white)
        }
        .frame(height: 320)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 10)
    }
}

// MARK: - Content Section
struct ContentSection: View {
    let title: String
    let items: [ContentItem]
    let colorScheme: ColorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                Spacer()
                Text("See All")
                    .font(.subheadline)
                    .foregroundColor(AppColors.primary(for: colorScheme))
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items) { item in
                        ContentCard(item: item, colorScheme: colorScheme)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Content Card
struct ContentCard: View {
    let item: ContentItem
    let colorScheme: ColorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Image
            ZStack(alignment: .topTrailing) {
                if let thumbnail = item.thumbnail, let url = URL(string: thumbnail) {
                    AsyncImage(url: url) { phase in
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
                                        .font(.system(size: 40))
                                        .foregroundColor(categoryColor(for: item.category))
                                )
                        }
                    }
                } else {
                    Rectangle()
                        .fill(categoryColor(for: item.category).opacity(0.3))
                        .overlay(
                            Image(systemName: iconForCategory(item.category))
                                .font(.system(size: 40))
                                .foregroundColor(categoryColor(for: item.category))
                        )
                }

                if item.isBookmarked {
                    Image(systemName: "lock.fill")
                        .font(.caption)
                        .padding(6)
                        .background(.black.opacity(0.5))
                        .clipShape(Circle())
                        .padding(8)
                        .foregroundColor(.white)
                }
            }
            .frame(width: 150, height: 150)
            .cornerRadius(16)

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                    .lineLimit(1)

                if let duration = item.duration {
                    Text("\(duration) min • \(item.type.rawValue)")
                        .font(.caption)
                        .foregroundColor(colorScheme == .dark ? AppColors.Dark.textSecondary : AppColors.Light.textSecondary)
                }
            }
        }
        .frame(width: 150)
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

// MARK: - Category Grid
struct CategoryGrid: View {
    let colorScheme: ColorScheme

    let categories = [
        ("Sleep", "moon.fill", Color.purple),
        ("Anxiety", "wind", Color.blue),
        ("Focus", "brain.head.profile", Color.orange),
        ("Kids", "figure.and.child.holdinghands", Color.green)
    ]

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(categories, id: \.0) { cat in
                HStack {
                    Image(systemName: cat.1)
                        .font(.title2)
                        .foregroundColor(cat.2)
                    Text(cat.0)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? .white : AppColors.Light.textPrimary)
                    Spacer()
                }
                .padding()
                .background(colorScheme == .dark ? AppColors.Dark.discoverSurface : Color.white)
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Placeholder Extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// MARK: - Preview
#Preview {
    DiscoverScreen()
        .environmentObject(ThemeViewModel())
        .environmentObject(AuthViewModel())
}
