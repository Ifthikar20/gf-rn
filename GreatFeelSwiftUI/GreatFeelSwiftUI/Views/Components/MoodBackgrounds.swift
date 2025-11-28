//
//  MoodBackgrounds.swift
//  GreatFeelSwiftUI
//
//  Animated background components for different moods
//

import SwiftUI

// MARK: - Cozy Warm Background (Rising Embers)
struct CozyWarmBackground: View {
    var body: some View {
        ZStack {
            // Warm glow at the bottom
            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, Color(hex: "FF7F50").opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 300)
            }

            GeometryReader { proxy in
                ForEach(0..<15, id: \.self) { index in
                    EmberParticle(bounds: proxy.size, index: index)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct EmberParticle: View {
    let bounds: CGSize
    let index: Int
    @State private var position: CGPoint = .zero
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Circle()
            .fill(Color(hex: "FF9A56"))
            .frame(width: 8, height: 8)
            .blur(radius: 2)
            .scaleEffect(scale)
            .position(position)
            .opacity(opacity)
            .onAppear {
                // Stagger start times
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                    resetAnimation()
                }
            }
    }

    func resetAnimation() {
        // Start at random x, near bottom y
        let startX = CGFloat.random(in: 0...bounds.width)
        let startY = bounds.height + CGFloat.random(in: 10...100)
        position = CGPoint(x: startX, y: startY)
        opacity = Double.random(in: 0.3...0.7)
        scale = CGFloat.random(in: 0.5...1.2)

        let duration = Double.random(in: 4...8)

        withAnimation(.linear(duration: duration)) {
            position.y = -50 // Float up off screen
            opacity = 0
        }

        // Restart after finish
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            resetAnimation()
        }
    }
}

// MARK: - Rain & River Background
struct RainRiverBackground: View {
    @Binding var triggerEffect: Bool
    @State private var thunderOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Rain drops
            GeometryReader { proxy in
                ForEach(0..<30, id: \.self) { index in
                    RainDrop(bounds: proxy.size, index: index)
                }
            }

            // Thunder flash overlay
            Color.white
                .opacity(thunderOpacity)
                .ignoresSafeArea()
                .onChange(of: triggerEffect) { _ in
                    // Flash animation
                    withAnimation(.easeIn(duration: 0.1)) {
                        thunderOpacity = 0.4
                    }
                    withAnimation(.easeOut(duration: 0.3).delay(0.1)) {
                        thunderOpacity = 0.0
                    }
                }
        }
        .allowsHitTesting(false)
    }
}

struct RainDrop: View {
    let bounds: CGSize
    let index: Int
    @State private var position: CGPoint = .zero

    var body: some View {
        Capsule()
            .fill(Color.white.opacity(0.3))
            .frame(width: 2, height: 25)
            .position(position)
            .onAppear {
                // Stagger start times
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    resetAnimation()
                }
            }
    }

    func resetAnimation() {
        let startX = CGFloat.random(in: 0...bounds.width)
        position = CGPoint(x: startX, y: -30)

        let duration = Double.random(in: 0.8...1.5)
        let endX = startX - 20 // slight diagonal fall

        withAnimation(.linear(duration: duration)) {
            position = CGPoint(x: endX, y: bounds.height + 30)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            resetAnimation()
        }
    }
}

// MARK: - Energetic Sparkles Background
struct EnergeticSparklesBackground: View {
    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<20, id: \.self) { index in
                SparkleParticle(bounds: proxy.size, index: index)
            }
        }
        .allowsHitTesting(false)
    }
}

struct SparkleParticle: View {
    let bounds: CGSize
    let index: Int
    @State private var position: CGPoint = .zero
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 0.1

    var body: some View {
        Image(systemName: "sparkle")
            .font(.system(size: 20))
            .foregroundColor(Color(hex: "FEE140"))
            .scaleEffect(scale)
            .position(position)
            .opacity(opacity)
            .onAppear {
                // Stagger start times
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                    resetAnimation()
                }
            }
    }

    func resetAnimation() {
        let randomX = CGFloat.random(in: 0...bounds.width)
        let randomY = CGFloat.random(in: 0...bounds.height)
        position = CGPoint(x: randomX, y: randomY)
        opacity = 0
        scale = 0.1

        // Appear and grow
        withAnimation(.easeOut(duration: 0.5)) {
            opacity = Double.random(in: 0.5...0.9)
            scale = CGFloat.random(in: 0.8...1.5)
        }

        // Disappear
        withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
            opacity = 0
            scale = 0.1
        }

        // Restart after finish
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2...4)) {
            resetAnimation()
        }
    }
}

// MARK: - Happy Bubbles Background
struct HappyBubblesBackground: View {
    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<12, id: \.self) { index in
                BubbleParticle(bounds: proxy.size, index: index)
            }
        }
        .allowsHitTesting(false)
    }
}

struct BubbleParticle: View {
    let bounds: CGSize
    let index: Int
    @State private var position: CGPoint = .zero
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Circle()
            .stroke(Color(hex: "FFE66D").opacity(0.6), lineWidth: 2)
            .frame(width: 30, height: 30)
            .scaleEffect(scale)
            .position(position)
            .opacity(opacity)
            .onAppear {
                // Stagger start times
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.4) {
                    resetAnimation()
                }
            }
    }

    func resetAnimation() {
        // Start at random x, near bottom y
        let startX = CGFloat.random(in: 0...bounds.width)
        let startY = bounds.height + 50
        position = CGPoint(x: startX, y: startY)
        opacity = Double.random(in: 0.4...0.7)
        scale = CGFloat.random(in: 0.5...1.0)

        let duration = Double.random(in: 5...8)

        // Float up with slight wobble
        let midX = startX + CGFloat.random(in: -30...30)

        withAnimation(.linear(duration: duration / 2)) {
            position = CGPoint(x: midX, y: bounds.height / 2)
        }

        withAnimation(.linear(duration: duration / 2).delay(duration / 2)) {
            position = CGPoint(x: startX, y: -50)
            opacity = 0
        }

        // Restart after finish
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            resetAnimation()
        }
    }
}

// MARK: - Nervous Pulse Background
struct NervousPulseBackground: View {
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .stroke(Color(hex: "B8B8FF").opacity(0.2), lineWidth: 2)
                    .frame(width: 100 + CGFloat(index) * 60, height: 100 + CGFloat(index) * 60)
                    .scaleEffect(pulseScale)
                    .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                    .opacity(1.0 - (Double(index) * 0.15))
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                pulseScale = 1.3
            }
        }
    }
}
