//
//  EnhancedMoodBackgrounds.swift
//  GreatFeelSwiftUI
//
//  Enhanced animated background components with aurora, lightning, and more
//

import SwiftUI

// MARK: - Additional Color Constants
extension Color {
    static let auroraBlue = Color(hex: "4A90E2")
    static let auroraPurple = Color(hex: "9B59B6")
    static let auroraGreen = Color(hex: "2ECC71")
    static let fireYellow = Color(hex: "F39C12")
    static let fireRed = Color(hex: "E74C3C")
    static let darkGray = Color(red: 0.2, green: 0.2, blue: 0.2)
}

// MARK: - Tree Enhancement Components

struct StarfieldEffect: View {
    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<60, id: \.self) { index in
                TwinklingStar(bounds: proxy.size, index: index)
            }
        }
    }
}

struct TwinklingStar: View {
    let bounds: CGSize
    let index: Int
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 1.0
    let position: CGPoint

    init(bounds: CGSize, index: Int) {
        self.bounds = bounds
        self.index = index
        self.position = CGPoint(
            x: CGFloat.random(in: 0...bounds.width),
            y: CGFloat.random(in: 0...bounds.height * 0.6)
        )
    }

    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: CGFloat.random(in: 1...3), height: CGFloat.random(in: 1...3))
            .scaleEffect(scale)
            .position(position)
            .opacity(opacity)
            .onAppear {
                let delay = Double.random(in: 0...3) + Double(index) * 0.05
                let duration = Double.random(in: 1.5...4)

                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                        opacity = Double.random(in: 0.3...0.9)
                        scale = CGFloat.random(in: 0.7...1.3)
                    }
                }
            }
    }
}

struct AuroraEffect: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { i in
                AuroraWave(index: i, offset: offset)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                offset = 500
            }
        }
    }
}

struct AuroraWave: View {
    let index: Int
    let offset: CGFloat

    private var auroraGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.auroraBlue.opacity(0.15),
                Color.auroraPurple.opacity(0.2),
                Color.auroraGreen.opacity(0.15),
                Color(hex: "7D5FFF").opacity(0.1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        WavePath(offset: offset, phase: Double(index) * .pi / 1.2)
            .fill(auroraGradient)
            .blur(radius: 25)
            .offset(y: CGFloat(index) * 80)
    }
}

struct WavePath: Shape {
    var offset: CGFloat
    var phase: Double

    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height * 0.3

        path.move(to: CGPoint(x: 0, y: midHeight))

        for x in stride(from: 0, through: width, by: 5) {
            let relativeX = x / width
            let sine = sin((relativeX * .pi * 4) + phase + (offset * 0.02))
            let y = midHeight + sine * 50
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()

        return path
    }
}

struct ShootingStarsEffect: View {
    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<3, id: \.self) { i in
                ShootingStar(bounds: proxy.size, delay: Double(i) * 8)
            }
        }
    }
}

struct ShootingStar: View {
    let bounds: CGSize
    let delay: Double
    @State private var startPoint: CGPoint = .zero
    @State private var endPoint: CGPoint = .zero
    @State private var opacity: Double = 0.0

    var body: some View {
        Path { path in
            path.move(to: startPoint)
            path.addLine(to: endPoint)
        }
        .stroke(
            LinearGradient(
                colors: [.white, .auroraBlue.opacity(0.6), .clear],
                startPoint: .leading,
                endPoint: .trailing
            ),
            style: StrokeStyle(lineWidth: 2, lineCap: .round)
        )
        .blur(radius: 1)
        .opacity(opacity)
        .onAppear {
            animateShootingStar()
        }
    }

    func animateShootingStar() {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            startPoint = CGPoint(x: bounds.width * CGFloat.random(in: 0.5...1), y: CGFloat.random(in: 0...bounds.height * 0.3))
            endPoint = startPoint

            withAnimation(.easeIn(duration: 0.1)) {
                opacity = 1.0
            }

            withAnimation(.easeOut(duration: 1.2)) {
                endPoint = CGPoint(
                    x: startPoint.x - CGFloat.random(in: 100...200),
                    y: startPoint.y + CGFloat.random(in: 80...150)
                )
            }

            withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
                opacity = 0.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 8...15)) {
                animateShootingStar()
            }
        }
    }
}

struct MagicalOrbsEffect: View {
    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<12, id: \.self) { index in
                MagicalOrb(bounds: proxy.size, index: index)
            }
        }
    }
}

struct MagicalOrb: View {
    let bounds: CGSize
    let index: Int
    @State private var position: CGPoint = .zero
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color.auroraPurple.opacity(0.8),
                        Color.auroraBlue.opacity(0.4),
                        .clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 15
                )
            )
            .frame(width: 12, height: 12)
            .blur(radius: 4)
            .scaleEffect(scale)
            .position(position)
            .opacity(opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                    animateOrb()
                }
            }
    }

    func animateOrb() {
        position = CGPoint(
            x: CGFloat.random(in: 0...bounds.width),
            y: CGFloat.random(in: bounds.height * 0.3...bounds.height * 0.9)
        )

        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            scale = CGFloat.random(in: 0.6...1.4)
            opacity = Double.random(in: 0.3...0.7)
        }

        let duration = Double.random(in: 8...15)
        withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
            position.x += CGFloat.random(in: -80...80)
            position.y += CGFloat.random(in: -60...60)
        }
    }
}

struct FirefliesEnhancedEffect: View {
    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<20, id: \.self) { index in
                Firefly(bounds: proxy.size, index: index)
            }
        }
    }
}

struct Firefly: View {
    let bounds: CGSize
    let index: Int
    @State private var position: CGPoint = .zero
    @State private var opacity: Double = 0.0
    @State private var scale: CGFloat = 1.0

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [.white, .auroraGreen.opacity(0.8), .clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: 8
                )
            )
            .frame(width: 8, height: 8)
            .blur(radius: 2)
            .scaleEffect(scale)
            .position(position)
            .opacity(opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                    animateFirefly()
                }
            }
    }

    func animateFirefly() {
        position = CGPoint(
            x: CGFloat.random(in: 0...bounds.width),
            y: CGFloat.random(in: bounds.height * 0.2...bounds.height * 0.8)
        )

        let duration = Double.random(in: 3...6)

        // Pulse animation
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            scale = CGFloat.random(in: 0.5...1.5)
            opacity = Double.random(in: 0.3...0.9)
        }

        // Movement animation
        withAnimation(.easeInOut(duration: duration)) {
            position = CGPoint(
                x: CGFloat.random(in: 0...bounds.width),
                y: CGFloat.random(in: bounds.height * 0.2...bounds.height * 0.8)
            )
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            animateFirefly()
        }
    }
}

// MARK: - Rain Enhancement Components

struct MovingCloudsEffect: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<5, id: \.self) { i in
                MovingCloud(index: i, offset: offset)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                offset = -1000
            }
        }
    }
}

struct MovingCloud: View {
    let index: Int
    let offset: CGFloat

    private var cloudGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.gray.opacity(0.15),
                Color.darkGray.opacity(0.25),
                Color.gray.opacity(0.15)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        CloudShape()
            .fill(cloudGradient)
            .frame(width: CGFloat.random(in: 200...400), height: CGFloat.random(in: 60...100))
            .blur(radius: 20)
            .offset(
                x: offset + CGFloat(index) * 300,
                y: CGFloat(index) * 50 + 50
            )
    }
}

struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: rect.minX, y: rect.midY, width: rect.width * 0.4, height: rect.height * 0.6))
        path.addEllipse(in: CGRect(x: rect.width * 0.2, y: rect.minY, width: rect.width * 0.5, height: rect.height * 0.8))
        path.addEllipse(in: CGRect(x: rect.width * 0.5, y: rect.midY, width: rect.width * 0.5, height: rect.height * 0.6))
        return path
    }
}

struct FogEffect: View {
    @State private var fogOffset1: CGFloat = 0
    @State private var fogOffset2: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                FogLayer(index: i, offset: i == 0 ? fogOffset1 : fogOffset2)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                fogOffset1 = 500
            }
            withAnimation(.linear(duration: 25).repeatForever(autoreverses: false)) {
                fogOffset2 = -500
            }
        }
    }
}

struct FogLayer: View {
    let index: Int
    let offset: CGFloat

    private var fogGradient: LinearGradient {
        LinearGradient(
            colors: [
                .clear,
                Color.gray.opacity(0.1),
                Color.white.opacity(0.05),
                .clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        Rectangle()
            .fill(fogGradient)
            .blur(radius: 40)
            .offset(x: offset)
            .offset(y: CGFloat(index) * 150)
    }
}

struct LightningBolt: Shape {
    let pathVariant: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startX = rect.width * CGFloat.random(in: 0.3...0.7)

        path.move(to: CGPoint(x: startX, y: 0))

        var currentX = startX
        var currentY: CGFloat = 0

        for _ in 0..<6 {
            currentY += rect.height / 8
            currentX += CGFloat.random(in: -40...40)
            path.addLine(to: CGPoint(x: currentX, y: currentY))

            // Random branches
            if Bool.random() {
                let branchX = currentX + CGFloat.random(in: -30...30)
                let branchY = currentY + 30
                path.move(to: CGPoint(x: currentX, y: currentY))
                path.addLine(to: CGPoint(x: branchX, y: branchY))
                path.move(to: CGPoint(x: currentX, y: currentY))
            }
        }

        return path
    }
}

struct RainSplashEnhancedEffect: View {
    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<35, id: \.self) { index in
                RainSplash(bounds: proxy.size, index: index)
            }
        }
    }
}

struct RainSplash: View {
    let bounds: CGSize
    let index: Int
    @State private var position: CGPoint = .zero
    @State private var scale: CGFloat = 0.0
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.white.opacity(0.5), lineWidth: 1.5)
                .frame(width: 25, height: 25)

            Circle()
                .strokeBorder(Color.cyan.opacity(0.3), lineWidth: 1)
                .frame(width: 25, height: 25)
                .scaleEffect(scale * 1.5)
                .opacity(opacity * 0.5)
        }
        .scaleEffect(scale)
        .position(position)
        .opacity(opacity)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                animateSplash()
            }
        }
    }

    func animateSplash() {
        position = CGPoint(
            x: CGFloat.random(in: 0...bounds.width),
            y: bounds.height - CGFloat.random(in: 30...80)
        )

        scale = 0.1
        opacity = 0.9

        withAnimation(.easeOut(duration: 0.6)) {
            scale = 1.8
            opacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.3...1.5)) {
            animateSplash()
        }
    }
}

// MARK: - Cozy Enhancement Components

struct HeatWaveEffect: View {
    @State private var phase: Double = 0

    private var waveGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.fireYellow.opacity(0.1),
                Color(hex: "FF7F50").opacity(0.15),
                Color.fireRed.opacity(0.1)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<6, id: \.self) { i in
                HeatWaveLine(index: i, phase: phase, bounds: proxy.size, gradient: waveGradient)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

struct HeatWaveLine: View {
    let index: Int
    let phase: Double
    let bounds: CGSize
    let gradient: LinearGradient

    var body: some View {
        HeatWaveShape(index: index, phase: phase)
            .stroke(gradient, lineWidth: 2)
            .blur(radius: 5)
    }
}

struct HeatWaveShape: Shape {
    let index: Int
    let phase: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let y = rect.height * (0.5 + CGFloat(index) * 0.1)
        path.move(to: CGPoint(x: 0, y: y))

        for x in stride(from: 0, through: rect.width, by: 10) {
            let relativeX = x / rect.width
            let sine = sin((relativeX * .pi * 3) + phase + Double(index) * 0.5)
            let offsetY = y + sine * 8
            path.addLine(to: CGPoint(x: x, y: offsetY))
        }

        return path
    }
}

struct SparkleEffect: View {
    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<15, id: \.self) { index in
                Sparkle(bounds: proxy.size, index: index)
            }
        }
    }
}

struct Sparkle: View {
    let bounds: CGSize
    let index: Int
    @State private var position: CGPoint = .zero
    @State private var opacity: Double = 0.0
    @State private var rotation: Double = 0.0

    var body: some View {
        Image(systemName: "sparkle")
            .font(.system(size: CGFloat.random(in: 8...14)))
            .foregroundColor(.fireYellow)
            .rotationEffect(.degrees(rotation))
            .position(position)
            .opacity(opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                    animateSparkle()
                }
            }
    }

    func animateSparkle() {
        position = CGPoint(
            x: CGFloat.random(in: 0...bounds.width),
            y: CGFloat.random(in: bounds.height * 0.5...bounds.height)
        )

        withAnimation(.easeInOut(duration: 1.5).repeatCount(1, autoreverses: true)) {
            opacity = Double.random(in: 0.4...0.8)
        }

        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            rotation = 360
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2...5)) {
            animateSparkle()
        }
    }
}
