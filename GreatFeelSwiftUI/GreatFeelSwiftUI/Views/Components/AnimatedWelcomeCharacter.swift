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
            // Try to load the SVG image from assets
            if let image = loadSVGImage() {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .scaleEffect(scale)
                    .opacity(opacity)
            } else {
                // Fallback icon if SVG not found
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
            print("AnimatedWelcomeCharacter appeared - loading SVG...")

            // Zoom in animation
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }

    private func loadSVGImage() -> UIImage? {
        // Try to load preview.svg from the bundle
        if let url = Bundle.main.url(forResource: "preview", withExtension: "svg") {
            print("Found preview.svg at: \(url.path)")

            // For iOS 13+, we can use UIImage with SVG support
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                print("Successfully loaded SVG image")
                return image
            } else {
                print("Failed to create UIImage from SVG data")
            }
        } else {
            print("preview.svg not found in bundle")
        }

        return nil
    }
}

#Preview {
    ZStack {
        Color.white
        AnimatedWelcomeCharacter()
    }
}
