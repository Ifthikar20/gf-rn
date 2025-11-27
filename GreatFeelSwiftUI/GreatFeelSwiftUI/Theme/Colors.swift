//
//  Colors.swift
//  GreatFeelSwiftUI
//
//  Design system colors matching the original React Native theme
//

import SwiftUI

struct AppColors {
    // MARK: - Light Theme
    struct Light {
        // Primary Colors
        static let primary = Color(hex: "6366F1")        // Indigo
        static let secondary = Color(hex: "8B5CF6")      // Purple
        static let accent = Color(hex: "F59E0B")         // Amber

        // Semantic Colors
        static let success = Color(hex: "10B981")        // Green
        static let error = Color(hex: "EF4444")          // Red
        static let warning = Color(hex: "F59E0B")        // Amber
        static let info = Color(hex: "3B82F6")           // Blue

        // Background Colors
        static let background = Color(hex: "FFFFFF")
        static let backgroundSecondary = Color(hex: "F9FAFB")
        static let backgroundTertiary = Color(hex: "F3F4F6")

        // Surface Colors
        static let surface = Color(hex: "FFFFFF")
        static let surfaceSecondary = Color(hex: "F9FAFB")

        // Text Colors
        static let textPrimary = Color(hex: "111827")
        static let textSecondary = Color(hex: "6B7280")
        static let textTertiary = Color(hex: "9CA3AF")
        static let textDisabled = Color(hex: "D1D5DB")

        // Border Colors
        static let border = Color(hex: "E5E7EB")
        static let borderFocus = Color(hex: "6366F1")

        // Neutral Scale
        static let neutral50 = Color(hex: "F9FAFB")
        static let neutral100 = Color(hex: "F3F4F6")
        static let neutral200 = Color(hex: "E5E7EB")
        static let neutral300 = Color(hex: "D1D5DB")
        static let neutral400 = Color(hex: "9CA3AF")
        static let neutral500 = Color(hex: "6B7280")
        static let neutral600 = Color(hex: "4B5563")
        static let neutral700 = Color(hex: "374151")
        static let neutral800 = Color(hex: "1F2937")
        static let neutral900 = Color(hex: "111827")
    }

    // MARK: - Dark Theme
    struct Dark {
        // Primary Colors
        static let primary = Color(hex: "818CF8")        // Lighter Indigo
        static let secondary = Color(hex: "A78BFA")      // Lighter Purple
        static let accent = Color(hex: "FBBf24")         // Lighter Amber

        // Semantic Colors
        static let success = Color(hex: "34D399")        // Lighter Green
        static let error = Color(hex: "F87171")          // Lighter Red
        static let warning = Color(hex: "FBBF24")        // Lighter Amber
        static let info = Color(hex: "60A5FA")           // Lighter Blue

        // Background Colors
        static let background = Color(hex: "000000")
        static let backgroundSecondary = Color(hex: "0A0A0A")
        static let backgroundTertiary = Color(hex: "141414")

        // Surface Colors
        static let surface = Color(hex: "1A1A1A")
        static let surfaceSecondary = Color(hex: "262626")

        // Text Colors
        static let textPrimary = Color(hex: "F9FAFB")
        static let textSecondary = Color(hex: "D1D5DB")
        static let textTertiary = Color(hex: "9CA3AF")
        static let textDisabled = Color(hex: "4B5563")

        // Border Colors
        static let border = Color(hex: "374151")
        static let borderFocus = Color(hex: "818CF8")

        // Neutral Scale (reversed)
        static let neutral50 = Color(hex: "111827")
        static let neutral100 = Color(hex: "1F2937")
        static let neutral200 = Color(hex: "374151")
        static let neutral300 = Color(hex: "4B5563")
        static let neutral400 = Color(hex: "6B7280")
        static let neutral500 = Color(hex: "9CA3AF")
        static let neutral600 = Color(hex: "D1D5DB")
        static let neutral700 = Color(hex: "E5E7EB")
        static let neutral800 = Color(hex: "F3F4F6")
        static let neutral900 = Color(hex: "F9FAFB")
    }

    // MARK: - Category Colors (for goals and content types)
    struct Category {
        static let breath = Color(hex: "3B82F6")         // Blue
        static let meditation = Color(hex: "8B5CF6")     // Purple
        static let sleep = Color(hex: "6366F1")          // Indigo
        static let relax = Color(hex: "10B981")          // Green
        static let mindfulness = Color(hex: "F59E0B")    // Amber
        static let stress = Color(hex: "EF4444")         // Red
        static let anxiety = Color(hex: "EC4899")        // Pink
        static let productivity = Color(hex: "14B8A6")   // Teal
    }
}

// MARK: - Color Extension for Hex Support
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
            (a, r, g, b) = (255, 0, 0, 0)
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

// MARK: - Theme-aware Color Provider
extension AppColors {
    static func primary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Dark.primary : Light.primary
    }

    static func secondary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Dark.secondary : Light.secondary
    }

    static func background(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Dark.background : Light.background
    }

    static func textPrimary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Dark.textPrimary : Light.textPrimary
    }

    static func textSecondary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Dark.textSecondary : Light.textSecondary
    }

    static func surface(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Dark.surface : Light.surface
    }

    static func border(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Dark.border : Light.border
    }

    static func textTertiary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Dark.textTertiary : Light.textTertiary
    }
}
