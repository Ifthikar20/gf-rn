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
            // Warm glow gradient base
            VStack {
                Spacer()
                LinearGradient(
                    colors: [.clear, Color(hex: "FF7F50").opacity(0.2)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 400)
            }

            // Enhanced effects
            HeatWaveEffect()
            SparkleEffect()

            GeometryReader { proxy in
                ForEach(0..<25, id: \.self) { index in
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
            .frame(width: 6, height: 6) // Smaller particles
            .blur(radius: 3) // Softer look
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
        let startY = bounds.height + CGFloat.random(in: 10...50)
        position = CGPoint(x: startX, y: startY)

        // Lower max opacity for subtlety
        opacity = Double.random(in: 0.1...0.5)
        scale = CGFloat.random(in: 0.2...0.8)

        // Slower duration
        let duration = Double.random(in: 6...12)

        withAnimation(.linear(duration: duration)) {
            position.y = bounds.height * 0.4 // Don't fly all the way to top, fade out mid-way
            position.x += CGFloat.random(in: -20...20) // Slight drift
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
            // Enhanced atmospheric effects
            MovingCloudsEffect()
            FogEffect()

            // More rain drops for density
            GeometryReader { proxy in
                ForEach(0..<60, id: \.self) { index in
                    RainDrop(bounds: proxy.size, index: index)
                }
            }

            // Rain splashes
            RainSplashEnhancedEffect()

            // Thunder flash overlay
            Color.white
                .opacity(thunderOpacity)
                .ignoresSafeArea()
                .onChange(of: triggerEffect) { _ in
                    // Flash animation (less blinding)
                    withAnimation(.easeIn(duration: 0.15)) {
                        thunderOpacity = 0.3
                    }
                    withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
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
    @State private var opacity: Double = 0.0

    var body: some View {
        Capsule()
            .fill(Color.white)
            .frame(width: 1, height: CGFloat.random(in: 15...30)) // Thinner
            .position(position)
            .opacity(opacity)
            .onAppear {
                // Stagger start times
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    resetAnimation()
                }
            }
    }

    func resetAnimation() {
        let startX = CGFloat.random(in: 0...bounds.width)
        position = CGPoint(x: startX, y: -50)
        opacity = Double.random(in: 0.05...0.2) // Very subtle opacity

        let duration = Double.random(in: 1.0...2.0) // Slower fall
        let endX = startX - 10

        withAnimation(.linear(duration: duration)) {
            position = CGPoint(x: endX, y: bounds.height + 50)
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
