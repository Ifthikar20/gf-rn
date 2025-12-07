//
//  AnimatedWelcomeCharacter.swift
//  GreatFeelSwiftUI
//
//  Created by Claude Code
//

import SwiftUI
import Lottie

struct AnimatedWelcomeCharacter: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        LottieView(animation: .named("welcome_animation"))
            .playing(loopMode: .loop)
            .animationSpeed(1.0)
            .frame(width: 200, height: 200)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                // Zoom in animation
                withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
    }
}

// Alternative implementation using URL for remote Lottie file
struct AnimatedWelcomeCharacterRemote: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var animation: LottieAnimation?

    var body: some View {
        Group {
            if let animation = animation {
                LottieView(animation: animation)
                    .playing(loopMode: .loop)
                    .animationSpeed(1.0)
                    .frame(width: 200, height: 200)
                    .scaleEffect(scale)
                    .opacity(opacity)
            } else {
                // Loading placeholder
                ProgressView()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            loadAnimation()

            // Zoom in animation
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }

    private func loadAnimation() {
        // The Lottie file URL
        let urlString = "https://lottie.host/4c06608c-2993-47d3-b53c-fc19682d98a6/bEHya1jQoO.json"

        guard let url = URL(string: urlString) else { return }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let loadedAnimation = try? LottieAnimation.from(data: data) {
                    await MainActor.run {
                        self.animation = loadedAnimation
                    }
                }
            } catch {
                print("Failed to load Lottie animation: \(error)")
            }
        }
    }
}

#Preview {
    ZStack {
        Color.white
        AnimatedWelcomeCharacterRemote()
    }
}
