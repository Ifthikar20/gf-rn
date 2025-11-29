//
//  LoginScreen.swift
//  GreatFeelSwiftUI
//
//  Login screen
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @Environment(\.colorScheme) var colorScheme

    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showError = false

    var body: some View {
        NavigationStack {
            ThemedBackground(opacity: 0.7) {
                ScrollView {
                    VStack(spacing: AppSpacing.xl) {
                        Spacer()
                            .frame(height: 40)

                        // Logo/Title
                        VStack(spacing: AppSpacing.sm) {
                            Image(systemName: "figure.mind.and.body")
                                .font(.system(size: 64))
                                .foregroundColor(AppColors.primary(for: colorScheme))

                            Text("GreatFeel")
                                .font(AppTypography.heading1())
                                .foregroundColor(AppColors.textPrimary(for: colorScheme))

                            Text("Welcome back! Sign in to continue")
                                .font(AppTypography.small())
                                .foregroundColor(AppColors.textSecondary(for: colorScheme))
                        }
                        .padding(.bottom, AppSpacing.lg)

                        // Form
                        VStack(spacing: AppSpacing.md) {
                            PrimaryInput(
                                label: "Email",
                                placeholder: "Enter your email",
                                text: $email,
                                errorMessage: nil,
                                icon: "envelope"
                            )

                            PrimaryInput(
                                label: "Password",
                                placeholder: "Enter your password",
                                text: $password,
                                isSecure: true,
                                errorMessage: nil,
                                icon: "lock"
                            )

                            // Remember Me & Forgot Password
                            HStack {
                                Button(action: { rememberMe.toggle() }) {
                                    HStack(spacing: AppSpacing.xs) {
                                        Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                                            .foregroundColor(AppColors.primary(for: colorScheme))
                                        Text("Remember me")
                                            .font(AppTypography.small())
                                            .foregroundColor(AppColors.textSecondary(for: colorScheme))
                                    }
                                }

                                Spacer()

                                NavigationLink(destination: ForgotPasswordScreen()) {
                                    Text("Forgot Password?")
                                        .font(AppTypography.small())
                                        .foregroundColor(AppColors.primary(for: colorScheme))
                                }
                            }
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

                        // Login Button
                        PrimaryButton(
                            "Sign In",
                            variant: .primary,
                            size: .large,
                            isLoading: authViewModel.isLoading,
                            isDisabled: !isFormValid
                        ) {
                            Task {
                                await authViewModel.login(email: email, password: password)
                            }
                        }

                        // Register Link
                        HStack(spacing: 4) {
                            Text("Don't have an account?")
                                .font(AppTypography.small())
                                .foregroundColor(AppColors.textSecondary(for: colorScheme))

                            NavigationLink(destination: RegisterScreen()) {
                                Text("Sign Up")
                                    .font(AppTypography.smallMedium())
                                    .foregroundColor(AppColors.primary(for: colorScheme))
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal, AppSpacing.xl)
                }
            }
        }
    }

    private var isFormValid: Bool {
        // Allow "admin" username or any email with @
        !email.isEmpty && !password.isEmpty && (email.lowercased() == "admin" || email.contains("@"))
    }
}

// MARK: - Preview
#Preview {
    LoginScreen()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeViewModel())
}
