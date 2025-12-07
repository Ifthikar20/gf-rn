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
    @State private var animation: LottieAnimation?
    @State private var isLoading = true

    var body: some View {
        ZStack {
            if let animation = animation {
                // Show Lottie animation when loaded
                LottieView(animation: animation)
                    .playing(loopMode: .loop)
                    .animationSpeed(1.0)
                    .frame(width: 200, height: 200)
                    .scaleEffect(scale)
                    .opacity(opacity)
            } else if isLoading {
                // Show loading indicator while animation loads
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading animation...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(width: 200, height: 200)
            } else {
                // Fallback if animation fails to load
                VStack(spacing: 12) {
                    Image(systemName: "figure.mind.and.body")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    Text("👋")
                        .font(.system(size: 40))
                }
                .frame(width: 200, height: 200)
                .scaleEffect(scale)
                .opacity(opacity)
            }
        }
        .onAppear {
            print("AnimatedWelcomeCharacter appeared - loading animation...")
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

        print("Loading Lottie animation from: \(urlString)")

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            isLoading = false
            return
        }

        Task {
            do {
                print("Fetching animation data...")
                let (data, response) = try await URLSession.shared.data(from: url)

                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status: \(httpResponse.statusCode)")
                }

                print("Data received: \(data.count) bytes")

                if let loadedAnimation = try? LottieAnimation.from(data: data) {
                    await MainActor.run {
                        print("Animation loaded successfully!")
                        self.animation = loadedAnimation
                        self.isLoading = false
                    }
                } else {
                    print("Failed to parse Lottie animation from data")
                    await MainActor.run {
                        self.isLoading = false
                    }
                }
            } catch {
                print("Failed to load Lottie animation: \(error.localizedDescription)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.white
        AnimatedWelcomeCharacter()
    }
}
