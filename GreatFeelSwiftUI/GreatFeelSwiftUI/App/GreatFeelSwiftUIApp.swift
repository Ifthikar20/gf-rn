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

    init() {
        print("🚀 GreatFeelSwiftUIApp launching...")
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(themeViewModel)
                .onAppear {
                    print("✅ RootView appeared - App is running!")
                }
        }
    }
}
