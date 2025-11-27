//
//  MainTabView.swift
//  GreatFeelSwiftUI
//
//  Main tab navigation
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TabView {
            // Goals Tab
            GoalsScreen()
                .tabItem {
                    Label("Goals", systemImage: "target")
                }
                .tag(0)

            // Library Tab
            LibraryScreen()
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
                .tag(1)

            // Relax Tab
            MeditateScreen()
                .tabItem {
                    Label("Relax", systemImage: "figure.mind.and.body")
                }
                .tag(2)

            // Discover Tab
            DiscoverScreen()
                .tabItem {
                    Label("Discover", systemImage: "safari")
                }
                .tag(3)

            // Profile Tab
            ProfileScreen()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(4)
        }
        .accentColor(AppColors.primary(for: colorScheme))
    }
}

// MARK: - Preview
#Preview {
    MainTabView()
        .environmentObject(ThemeViewModel())
        .environmentObject(AuthViewModel())
}
