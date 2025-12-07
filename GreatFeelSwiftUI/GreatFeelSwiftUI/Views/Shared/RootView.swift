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
    @State private var showOnboarding = false

    var body: some View {
        ZStack {
            Group {
                if authViewModel.isAuthenticated {
                    // Check if user completed onboarding
                    if UserDefaultsService.shared.hasCompletedOnboarding {
                        // User is logged in and completed onboarding - show main app
                        MainTabView()
                    } else {
                        // Show onboarding before main app
                        Color.clear
                    }
                } else {
                    // User is not logged in - show login screen
                    LoginScreen()
                }
            }
            .preferredColorScheme(preferredColorScheme)

            // Onboarding overlay (shows after welcome popup)
            if showOnboarding && authViewModel.isAuthenticated {
                OnboardingView(isPresented: $showOnboarding)
                    .transition(.opacity)
            }

            // Welcome popup overlay (shows first)
            if showWelcomePopup {
                WelcomePopup(isPresented: $showWelcomePopup)
                    .onDisappear {
                        // Mark as seen when dismissed
                        UserDefaultsService.shared.hasSeenWelcome = true

                        // Show onboarding if not completed
                        if authViewModel.isAuthenticated &&
                           !UserDefaultsService.shared.hasCompletedOnboarding {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation {
                                    showOnboarding = true
                                }
                            }
                        }
                    }
            }
        }
        .onAppear {
            print("RootView appeared")
            print("hasSeenWelcome: \(UserDefaultsService.shared.hasSeenWelcome)")

            // TEMPORARY: Always show popup for testing
            // TODO: Revert to check hasSeenWelcome after testing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("Showing welcome popup...")
                showWelcomePopup = true
            }

            // Original code (currently disabled for testing):
            // if !UserDefaultsService.shared.hasSeenWelcome {
            //     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //         showWelcomePopup = true
            //     }
            // }
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
