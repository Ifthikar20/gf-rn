//
//  ForgotPasswordScreen.swift
//  GreatFeelSwiftUI
//
//  Forgot password screen
//

import SwiftUI

struct ForgotPasswordScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    @State private var email = ""
    @State private var showSuccess = false

    var body: some View {
        ThemedBackground(opacity: 0.7) {
            VStack(spacing: AppSpacing.xl) {
                Spacer()

                // Icon
                Image(systemName: "envelope.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.primary(for: colorScheme))

                // Title and Description
                VStack(spacing: AppSpacing.sm) {
                    Text("Forgot Password?")
                        .font(AppTypography.heading2())
                        .foregroundColor(AppColors.textPrimary(for: colorScheme))

                    Text("Enter your email address and we'll send you instructions to reset your password")
                        .font(AppTypography.small())
                        .foregroundColor(AppColors.textSecondary(for: colorScheme))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppSpacing.lg)
                }

                // Form
                VStack(spacing: AppSpacing.md) {
                    PrimaryInput(
                        label: "Email",
                        placeholder: "Enter your email",
                        text: $email,
                        icon: "envelope"
                    )
                }
                .padding(.horizontal, AppSpacing.xl)

                // Error Message
                if let errorMessage = authViewModel.errorMessage {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(errorMessage)
                            .font(AppTypography.small())
                    }
                    .foregroundColor(AppColors.Light.error)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                    .background(AppColors.Light.error.opacity(0.1))
                    .cornerRadius(AppSpacing.Radius.md)
                    .padding(.horizontal, AppSpacing.xl)
                }

                // Success Message
                if showSuccess {
                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Reset instructions sent! Check your email.")
                            .font(AppTypography.small())
                    }
                    .foregroundColor(AppColors.Light.success)
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.vertical, AppSpacing.sm)
                    .background(AppColors.Light.success.opacity(0.1))
                    .cornerRadius(AppSpacing.Radius.md)
                    .padding(.horizontal, AppSpacing.xl)
                }

                // Send Button
                PrimaryButton(
                    "Send Reset Link",
                    variant: .primary,
                    size: .large,
                    isLoading: authViewModel.isLoading,
                    isDisabled: !isFormValid
                ) {
                    Task {
                        let success = await authViewModel.forgotPassword(email: email)
                        if success {
                            showSuccess = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                dismiss()
                            }
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.xl)

                // Back to Login
                Button(action: { dismiss() }) {
                    Text("Back to Sign In")
                        .font(AppTypography.smallMedium())
                        .foregroundColor(AppColors.primary(for: colorScheme))
                }

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var isFormValid: Bool {
        !email.isEmpty && email.contains("@")
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ForgotPasswordScreen()
            .environmentObject(AuthViewModel())
    }
}
