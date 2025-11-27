//
//  Typography.swift
//  GreatFeelSwiftUI
//
//  Typography system matching the original design
//

import SwiftUI

struct AppTypography {
    // MARK: - Font Sizes
    enum Size {
        static let xs: CGFloat = 12
        static let sm: CGFloat = 14
        static let base: CGFloat = 16
        static let lg: CGFloat = 18
        static let xl: CGFloat = 20
        static let xl2: CGFloat = 24
        static let xl3: CGFloat = 30
        static let xl4: CGFloat = 36
        static let xl5: CGFloat = 48
    }

    // MARK: - Font Weights
    enum Weight {
        static let regular = Font.Weight.regular      // 400
        static let medium = Font.Weight.medium        // 500
        static let semibold = Font.Weight.semibold    // 600
        static let bold = Font.Weight.bold            // 700
    }

    // MARK: - Predefined Styles
    static func heading1() -> Font {
        .system(size: Size.xl5, weight: Weight.bold)
    }

    static func heading2() -> Font {
        .system(size: Size.xl4, weight: Weight.bold)
    }

    static func heading3() -> Font {
        .system(size: Size.xl3, weight: Weight.semibold)
    }

    static func heading4() -> Font {
        .system(size: Size.xl2, weight: Weight.semibold)
    }

    static func heading5() -> Font {
        .system(size: Size.xl, weight: Weight.semibold)
    }

    static func heading6() -> Font {
        .system(size: Size.lg, weight: Weight.semibold)
    }

    static func body() -> Font {
        .system(size: Size.base, weight: Weight.regular)
    }

    static func bodyMedium() -> Font {
        .system(size: Size.base, weight: Weight.medium)
    }

    static func bodySemibold() -> Font {
        .system(size: Size.base, weight: Weight.semibold)
    }

    static func small() -> Font {
        .system(size: Size.sm, weight: Weight.regular)
    }

    static func smallMedium() -> Font {
        .system(size: Size.sm, weight: Weight.medium)
    }

    static func caption() -> Font {
        .system(size: Size.xs, weight: Weight.regular)
    }

    static func captionMedium() -> Font {
        .system(size: Size.xs, weight: Weight.medium)
    }

    static func button() -> Font {
        .system(size: Size.base, weight: Weight.semibold)
    }

    static func buttonSmall() -> Font {
        .system(size: Size.sm, weight: Weight.semibold)
    }
}

// MARK: - View Extension for Easy Typography Application
extension View {
    func typography(_ style: AppTypographyStyle) -> some View {
        self.font(style.font)
    }
}

// MARK: - Typography Style Enum
enum AppTypographyStyle {
    case h1, h2, h3, h4, h5, h6
    case body, bodyMedium, bodySemibold
    case small, smallMedium
    case caption, captionMedium
    case button, buttonSmall

    var font: Font {
        switch self {
        case .h1: return AppTypography.heading1()
        case .h2: return AppTypography.heading2()
        case .h3: return AppTypography.heading3()
        case .h4: return AppTypography.heading4()
        case .h5: return AppTypography.heading5()
        case .h6: return AppTypography.heading6()
        case .body: return AppTypography.body()
        case .bodyMedium: return AppTypography.bodyMedium()
        case .bodySemibold: return AppTypography.bodySemibold()
        case .small: return AppTypography.small()
        case .smallMedium: return AppTypography.smallMedium()
        case .caption: return AppTypography.caption()
        case .captionMedium: return AppTypography.captionMedium()
        case .button: return AppTypography.button()
        case .buttonSmall: return AppTypography.buttonSmall()
        }
    }
}
