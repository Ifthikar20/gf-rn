//
//  AnimatedWelcomeCharacter.swift
//  GreatFeelSwiftUI
//
//  Created by Claude Code
//

import SwiftUI

struct AnimatedWelcomeCharacter: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // Try to load the welcome character image
            if let image = UIImage(named: "welcome-character") {
                print("✅ Found welcome-character image!")
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .scaleEffect(scale)
                    .opacity(opacity)
            } else {
                print("⚠️ welcome-character image NOT found - showing fallback")
                // Fallback icon if image not found - MORE VISIBLE
                ZStack {
                    // Background circle to make it stand out
                    Circle()
                        .fill(Color.white)
                        .frame(width: 220, height: 220)
                        .shadow(color: .black.opacity(0.2), radius: 10)

                    VStack(spacing: 16) {
                        Image(systemName: "figure.mind.and.body")
                            .font(.system(size: 100))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text("👋")
                            .font(.system(size: 50))
                    }
                }
                .frame(width: 200, height: 200)
                .scaleEffect(scale)
                .opacity(opacity)
            }
        }
        .onAppear {
            print("AnimatedWelcomeCharacter appeared - loading image...")

            // Zoom in animation
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
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
