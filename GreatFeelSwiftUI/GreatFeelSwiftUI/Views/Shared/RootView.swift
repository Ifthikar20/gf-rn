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

    var body: some View {
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
