//
//  PrimaryButton.swift
//  GreatFeelSwiftUI
//
//  Reusable button component
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let variant: ButtonVariant
    let size: ButtonSize
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void

    @Environment(\.colorScheme) var colorScheme

    init(
        _ title: String,
        variant: ButtonVariant = .primary,
        size: ButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.8)
                }

                Text(title)
                    .font(size.font)
                    .foregroundColor(textColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: size.height)
            .background(backgroundColor)
            .cornerRadius(AppSpacing.Radius.full)
            .opacity(isDisabled || isLoading ? 0.6 : 1.0)
        }
        .disabled(isDisabled || isLoading)
    }

    private var backgroundColor: Color {
        switch variant {
        case .primary:
            return AppColors.primary(for: colorScheme)
        case .secondary:
            return AppColors.secondary(for: colorScheme)
        case .outline:
            return Color.clear
        case .ghost:
            return Color.clear
        }
    }

    private var textColor: Color {
        switch variant {
        case .primary, .secondary:
            return .white
        case .outline, .ghost:
            return AppColors.primary(for: colorScheme)
        }
    }
}

// MARK: - Button Variant
enum ButtonVariant {
    case primary
    case secondary
    case outline
    case ghost
}

// MARK: - Button Size
enum ButtonSize {
    case small
    case medium
    case large

    var height: CGFloat {
        switch self {
        case .small: return 36
        case .medium: return 48
        case .large: return 56
        }
    }

    var font: Font {
        switch self {
        case .small: return AppTypography.buttonSmall()
        case .medium, .large: return AppTypography.button()
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: AppSpacing.md) {
        PrimaryButton("Primary Button", variant: .primary) {}
        PrimaryButton("Secondary Button", variant: .secondary) {}
        PrimaryButton("Outline Button", variant: .outline) {}
        PrimaryButton("Loading", isLoading: true) {}
        PrimaryButton("Disabled", isDisabled: true) {}
    }
    .padding()
}
