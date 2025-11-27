//
//  Spacing.swift
//  GreatFeelSwiftUI
//
//  Spacing and layout constants
//

import SwiftUI

struct AppSpacing {
    // MARK: - Spacing Scale
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xl2: CGFloat = 48
    static let xl3: CGFloat = 64

    // MARK: - Border Radius
    struct Radius {
        static let sm: CGFloat = 4
        static let md: CGFloat = 8
        static let lg: CGFloat = 12
        static let xl: CGFloat = 16
        static let xl2: CGFloat = 24
        static let full: CGFloat = 9999
    }

    // MARK: - Shadows
    struct Shadow {
        static let small = ShadowStyle(
            color: Color.black.opacity(0.1),
            radius: 2,
            x: 0,
            y: 1
        )

        static let medium = ShadowStyle(
            color: Color.black.opacity(0.1),
            radius: 4,
            x: 0,
            y: 2
        )

        static let large = ShadowStyle(
            color: Color.black.opacity(0.15),
            radius: 8,
            x: 0,
            y: 4
        )

        static let xl = ShadowStyle(
            color: Color.black.opacity(0.2),
            radius: 16,
            x: 0,
            y: 8
        )
    }

    // MARK: - Icon Sizes
    struct IconSize {
        static let xs: CGFloat = 12
        static let sm: CGFloat = 16
        static let md: CGFloat = 20
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xl2: CGFloat = 40
        static let xl3: CGFloat = 48
    }
}

// MARK: - Shadow Style
struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions for Shadows
extension View {
    func appShadow(_ style: ShadowStyle) -> some View {
        self.shadow(color: style.color, radius: style.radius, x: style.x, y: style.y)
    }

    func cardShadow() -> some View {
        self.appShadow(AppSpacing.Shadow.medium)
    }

    func elevatedShadow() -> some View {
        self.appShadow(AppSpacing.Shadow.large)
    }
}
