//
//  AnimatedWelcomeCharacter.swift
//  GreatFeelSwiftUI
//
//  Created by Claude Code
//

import SwiftUI

struct AnimatedWelcomeCharacter: View {
    @State private var isWaving = false
    @State private var eyesBlink = false
    @State private var bodyBounce = false

    var body: some View {
        ZStack {
            // Character body
            VStack(spacing: 0) {
                // Head with face
                ZStack {
                    // Head circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#FFD93D"), Color(hex: "#FFC107")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

                    // Face
                    VStack(spacing: 12) {
                        // Eyes
                        HStack(spacing: 30) {
                            // Left eye
                            RoundedRectangle(cornerRadius: eyesBlink ? 1 : 10)
                                .fill(Color.black)
                                .frame(width: 12, height: eyesBlink ? 2 : 12)

                            // Right eye
                            RoundedRectangle(cornerRadius: eyesBlink ? 1 : 10)
                                .fill(Color.black)
                                .frame(width: 12, height: eyesBlink ? 2 : 12)
                        }
                        .offset(y: -5)

                        // Smile
                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addQuadCurve(
                                to: CGPoint(x: 40, y: 0),
                                control: CGPoint(x: 20, y: 15)
                            )
                        }
                        .stroke(Color.black, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 40, height: 15)
                        .offset(y: 5)
                    }
                }
                .offset(y: bodyBounce ? -8 : 0)

                // Body
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 100, height: 80)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .offset(y: -10)

                // Legs
                HStack(spacing: 20) {
                    Capsule()
                        .fill(Color(hex: "#6366F1"))
                        .frame(width: 25, height: 40)

                    Capsule()
                        .fill(Color(hex: "#6366F1"))
                        .frame(width: 25, height: 40)
                }
                .offset(y: -15)
            }

            // Waving hand (left side)
            Circle()
                .fill(Color(hex: "#FFD93D"))
                .frame(width: 35, height: 35)
                .overlay(
                    // Arm
                    Capsule()
                        .fill(Color(hex: "#6366F1"))
                        .frame(width: 15, height: 50)
                        .offset(y: 25)
                )
                .rotationEffect(.degrees(isWaving ? -30 : 30), anchor: .bottom)
                .offset(x: -70, y: -20)
                .animation(
                    .easeInOut(duration: 0.5)
                        .repeatForever(autoreverses: true),
                    value: isWaving
                )

            // Sparkles around character
            ForEach(0..<6, id: \.self) { index in
                SparkleView()
                    .offset(
                        x: CGFloat.random(in: -80...80),
                        y: CGFloat.random(in: -100...60)
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 1.5...2.5))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                        value: isWaving
                    )
            }
        }
        .onAppear {
            // Start animations
            isWaving = true
            startBlinking()
            startBouncing()
        }
    }

    private func startBlinking() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.1)) {
                eyesBlink = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    eyesBlink = false
                }
            }
        }
    }

    private func startBouncing() {
        withAnimation(
            .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
        ) {
            bodyBounce = true
        }
    }
}

// Sparkle effect for decoration
struct SparkleView: View {
    @State private var opacity: Double = 0.3
    @State private var scale: CGFloat = 0.5

    var body: some View {
        Image(systemName: "sparkle")
            .font(.system(size: 20))
            .foregroundStyle(
                LinearGradient(
                    colors: [Color(hex: "#F59E0B"), Color(hex: "#FCD34D")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                ) {
                    opacity = 1.0
                    scale = 1.0
                }
            }
    }
}

// Color extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ZStack {
        Color.white
        AnimatedWelcomeCharacter()
    }
}
