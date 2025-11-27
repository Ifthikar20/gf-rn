//
//  GreatFeelSwiftUIApp.swift
//  GreatFeelSwiftUI
//
//  Main app entry point
//

import SwiftUI

@main
struct GreatFeelSwiftUIApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var themeViewModel = ThemeViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(themeViewModel)
        }
    }
}
