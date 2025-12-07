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
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .scaleEffect(scale)
                    .opacity(opacity)
            } else {
                // Fallback icon if image not found
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
