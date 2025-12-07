//
//  RootView.swift
//  GreatFeelSwiftUI
//
//  Root view handling authentication state
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @Environment(\.colorScheme) var systemColorScheme

    @State private var showWelcomePopup = false

    var body: some View {
        ZStack {
            Group {
                if authViewModel.isAuthenticated {
                    // User is logged in - show main app
                    MainTabView()
                } else {
                    // User is not logged in - show login screen
                    LoginScreen()
                }
            }
            .preferredColorScheme(preferredColorScheme)

            // Welcome popup overlay
            if showWelcomePopup {
                WelcomePopup(isPresented: $showWelcomePopup)
                    .onDisappear {
                        // Mark as seen when dismissed
                        UserDefaultsService.shared.hasSeenWelcome = true
                    }
            }
        }
        .onAppear {
            // Show welcome popup on first launch
            if !UserDefaultsService.shared.hasSeenWelcome {
                // Delay slightly for better animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showWelcomePopup = true
                }
            }
        }
    }

    private var preferredColorScheme: ColorScheme? {
        switch themeViewModel.themeMode {
        case .light:
            return .light
        case .dark:
            return .dark
        case .auto:
            return nil // Use system preference
        }
    }
}

// MARK: - Preview
#Preview {
    RootView()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeViewModel())
}
