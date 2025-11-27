//
//  PrimaryInput.swift
//  GreatFeelSwiftUI
//
//  Reusable input field component
//

import SwiftUI

struct PrimaryInput: View {
    let label: String?
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let errorMessage: String?
    let icon: String?

    @Environment(\.colorScheme) var colorScheme
    @State private var isPasswordVisible = false
    @FocusState private var isFocused: Bool

    init(
        label: String? = nil,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        errorMessage: String? = nil,
        icon: String? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.errorMessage = errorMessage
        self.icon = icon
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            // Label
            if let label = label {
                Text(label)
                    .font(AppTypography.smallMedium())
                    .foregroundColor(AppColors.textSecondary(for: colorScheme))
            }

            // Input Field
            HStack(spacing: AppSpacing.sm) {
                // Leading Icon
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: AppSpacing.IconSize.md))
                        .foregroundColor(AppColors.textTertiary(for: colorScheme))
                }

                // Text Field
                Group {
                    if isSecure && !isPasswordVisible {
                        SecureField(placeholder, text: $text)
                            .focused($isFocused)
                    } else {
                        TextField(placeholder, text: $text)
                            .focused($isFocused)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                }
                .font(AppTypography.body())
                .foregroundColor(AppColors.textPrimary(for: colorScheme))

                // Password Visibility Toggle
                if isSecure {
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: AppSpacing.IconSize.md))
                            .foregroundColor(AppColors.textTertiary(for: colorScheme))
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm + 4)
            .background(AppColors.surface(for: colorScheme))
            .overlay(
                RoundedRectangle(cornerRadius: AppSpacing.Radius.md)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .cornerRadius(AppSpacing.Radius.md)

            // Error Message
            if let errorMessage = errorMessage {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: AppSpacing.IconSize.sm))
                    Text(errorMessage)
                        .font(AppTypography.caption())
                }
                .foregroundColor(colorScheme == .dark ? AppColors.Dark.error : AppColors.Light.error)
            }
        }
    }

    private var borderColor: Color {
        if let _ = errorMessage {
            return colorScheme == .dark ? AppColors.Dark.error : AppColors.Light.error
        }
        if isFocused {
            return AppColors.primary(for: colorScheme)
        }
        return AppColors.border(for: colorScheme)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: AppSpacing.lg) {
        PrimaryInput(
            label: "Email",
            placeholder: "Enter your email",
            text: .constant(""),
            icon: "envelope"
        )

        PrimaryInput(
            label: "Password",
            placeholder: "Enter your password",
            text: .constant(""),
            isSecure: true,
            icon: "lock"
        )

        PrimaryInput(
            label: "Email",
            placeholder: "Enter your email",
            text: .constant(""),
            errorMessage: "Invalid email address",
            icon: "envelope"
        )
    }
    .padding()
}
