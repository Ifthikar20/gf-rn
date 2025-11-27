//
//  LibraryViewModel.swift
//  GreatFeelSwiftUI
//
//  Library content state management
//

import Foundation
import Combine

@MainActor
class LibraryViewModel: ObservableObject {
    @Published var content: [ContentItem] = []
    @Published var selectedCategory: ContentCategory?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var bookmarkedIds: Set<String> = []

    init() {
        loadContent()
    }

    // MARK: - Load Content
    func loadContent() {
        isLoading = true
        errorMessage = nil

        // Simulate network delay
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            content = ContentItem.allMockContent

            // Load bookmarked items
            bookmarkedIds = Set(content.filter { $0.isBookmarked }.map { $0.id })

            isLoading = false
        }
    }

    // MARK: - Filter by Category
    func selectCategory(_ category: ContentCategory?) {
        selectedCategory = category
    }

    // MARK: - Toggle Bookmark
    func toggleBookmark(_ contentId: String) {
        if bookmarkedIds.contains(contentId) {
            bookmarkedIds.remove(contentId)
        } else {
            bookmarkedIds.insert(contentId)
        }

        // In a real app, you would update the backend here
    }

    func isBookmarked(_ contentId: String) -> Bool {
        bookmarkedIds.contains(contentId)
    }

    // MARK: - Filtered Content
    var filteredContent: [ContentItem] {
        guard let category = selectedCategory else {
            return content
        }
        return content.filter { $0.category == category }
    }

    // MARK: - Content by Category
    func content(for category: ContentCategory) -> [ContentItem] {
        content.filter { $0.category == category }
    }

    // MARK: - Content by Type
    func content(ofType type: ContentType) -> [ContentItem] {
        content.filter { $0.type == type }
    }

    var articles: [ContentItem] {
        content(ofType: .article)
    }

    var videos: [ContentItem] {
        content(ofType: .video)
    }

    var audio: [ContentItem] {
        content(ofType: .audio)
    }

    var meditations: [ContentItem] {
        content(ofType: .meditation)
    }

    // MARK: - Bookmarked Content
    var bookmarkedContent: [ContentItem] {
        content.filter { bookmarkedIds.contains($0.id) }
    }
}
