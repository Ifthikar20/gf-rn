//
//  RegisterScreen.swift
//  GreatFeelSwiftUI
//
//  Registration screen
//

import SwiftUI

struct RegisterScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var acceptTerms = false

    var body: some View {
        ThemedBackground(opacity: 0.7) {
            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    Spacer()
                        .frame(height: 20)

                    // Title
                    VStack(spacing: AppSpacing.sm) {
                        Text("Create Account")
                            .font(AppTypography.heading2())
                            .foregroundColor(AppColors.textPrimary(for: colorScheme))

                        Text("Sign up to get started")
                            .font(AppTypography.small())
                            .foregroundColor(AppColors.textSecondary(for: colorScheme))
                    }
                    .padding(.bottom, AppSpacing.lg)

                    // Form
                    VStack(spacing: AppSpacing.md) {
                        PrimaryInput(
                            label: "Name",
                            placeholder: "Enter your name",
                            text: $name,
                            icon: "person"
                        )

                        PrimaryInput(
                            label: "Email",
                            placeholder: "Enter your email",
                            text: $email,
                            icon: "envelope"
                        )

                        PrimaryInput(
                            label: "Password",
                            placeholder: "Create a password",
                            text: $password,
                            isSecure: true,
                            icon: "lock"
                        )

                        PrimaryInput(
                            label: "Confirm Password",
                            placeholder: "Re-enter your password",
                            text: $confirmPassword,
                            isSecure: true,
                            errorMessage: passwordMismatchError,
                            icon: "lock"
                        )

                        // Terms and Conditions
                        Button(action: { acceptTerms.toggle() }) {
                            HStack(spacing: AppSpacing.xs) {
                                Image(systemName: acceptTerms ? "checkmark.square.fill" : "square")
                                    .foregroundColor(AppColors.primary(for: colorScheme))

                                Text("I accept the Terms and Conditions")
                                    .font(AppTypography.small())
                                    .foregroundColor(AppColors.textSecondary(for: colorScheme))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

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
                    }

                    // Register Button
                    PrimaryButton(
                        "Create Account",
                        variant: .primary,
                        size: .large,
                        isLoading: authViewModel.isLoading,
                        isDisabled: !isFormValid
                    ) {
                        Task {
                            await authViewModel.register(
                                name: name,
                                email: email,
                                password: password,
                                confirmPassword: confirmPassword
                            )
                        }
                    }

                    // Login Link
                    HStack(spacing: 4) {
                        Text("Already have an account?")
                            .font(AppTypography.small())
                            .foregroundColor(AppColors.textSecondary(for: colorScheme))

                        Button(action: { dismiss() }) {
                            Text("Sign In")
                                .font(AppTypography.smallMedium())
                                .foregroundColor(AppColors.primary(for: colorScheme))
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, AppSpacing.xl)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        email.contains("@") &&
        !password.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword &&
        acceptTerms
    }

    private var passwordMismatchError: String? {
        if !confirmPassword.isEmpty && password != confirmPassword {
            return "Passwords do not match"
        }
        return nil
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        RegisterScreen()
            .environmentObject(AuthViewModel())
    }
}
