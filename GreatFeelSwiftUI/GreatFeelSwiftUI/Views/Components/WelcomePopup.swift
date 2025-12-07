//
//  WelcomePopup.swift
//  GreatFeelSwiftUI
//
//  Created by Claude Code
//

import SwiftUI

struct WelcomePopup: View {
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var characterBounce: CGFloat = 0
    @State private var bubbleScale: CGFloat = 0.8

    var body: some View {
        ZStack {
            // Background overlay with gradient
            LinearGradient(
                colors: [
                    Color.black.opacity(0.7),
                    Color(hex: "#1F2937").opacity(0.9)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .onTapGesture {
                dismissPopup()
            }

            VStack(spacing: 0) {
                // Character floating above
                AnimatedWelcomeCharacter()
                    .frame(width: 200, height: 200)
                    .offset(y: characterBounce)
                    .offset(y: -60) // Position above the dialogue box

                // Speech bubble / Dialogue box
                VStack(spacing: 0) {
                    // Triangle pointer at top
                    Triangle()
                        .fill(Color.white)
                        .frame(width: 30, height: 15)
                        .offset(y: 1)

                    // Main dialogue box
                    VStack(spacing: 20) {
                        // Welcome header with game-style text
                        HStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "#F59E0B"))

                            Text("Welcome, Traveler!")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            Image(systemName: "sparkles")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "#F59E0B"))
                        }

                        // Dialogue text
                        VStack(spacing: 12) {
                            Text("I'm so glad you're here!")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: "#1F2937"))

                            Text("Ready to begin your journey to mindfulness and wellness? Let's explore this magical world together!")
                                .font(.system(size: 16))
                                .foregroundColor(Color(hex: "#4B5563"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 8)

                        // Game-style button
                        Button(action: {
                            dismissPopup()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 18))

                                Text("Start Adventure")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))

                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 18))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                ZStack {
                                    // Outer glow
                                    LinearGradient(
                                        colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .blur(radius: 8)

                                    // Main gradient
                                    LinearGradient(
                                        colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                            )
                            .cornerRadius(20)
                            .shadow(color: Color(hex: "#8B5CF6").opacity(0.5), radius: 15, x: 0, y: 8)
                        }
                        .scaleEffect(bubbleScale)

                        // Decorative sparkles at bottom
                        HStack(spacing: 8) {
                            ForEach(0..<5, id: \.self) { _ in
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(hex: "#F59E0B"), Color(hex: "#FCD34D")],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .opacity(0.6)
                    }
                    .padding(32)
                    .background(
                        ZStack {
                            // Game-style border
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )

                            // White background
                            RoundedRectangle(cornerRadius: 24)
                                .fill(Color.white)
                        }
                    )
                    .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 15)
                }
                .padding(.horizontal, 24)
                .scaleEffect(scale)
                .opacity(opacity)
            }
            .offset(y: -40)
        }
        .onAppear {
            // Entry animation
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }

            // Character bounce animation
            withAnimation(
                .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true)
            ) {
                characterBounce = -10
            }

            // Button pulse animation
            withAnimation(
                .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                bubbleScale = 1.05
            }
        }
    }

    private func dismissPopup() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            scale = 0.8
            opacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}

// Triangle shape for speech bubble pointer
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    WelcomePopup(isPresented: .constant(true))
}
