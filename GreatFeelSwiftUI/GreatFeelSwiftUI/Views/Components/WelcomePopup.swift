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

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissPopup()
                }

            // Popup card
            VStack(spacing: 24) {
                // Animated character with Lottie animation
                AnimatedWelcomeCharacterRemote()
                    .frame(height: 250)

                // Welcome text
                VStack(spacing: 12) {
                    Text("Welcome to GreatFeel!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "#1F2937"))

                    Text("Your journey to mindfulness and wellness starts here. Let's explore together!")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#6B7280"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }

                // Get started button
                Button(action: {
                    dismissPopup()
                }) {
                    HStack(spacing: 8) {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .semibold))

                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#6366F1"), Color(hex: "#8B5CF6")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 32)
            .scaleEffect(scale)
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
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

#Preview {
    WelcomePopup(isPresented: .constant(true))
}
