//
//  AuthViewModel.swift
//  GreatFeelSwiftUI
//
//  Authentication state management
//

import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authAPI = AuthAPI()
    private let keychainService = KeychainService.shared
    private let userDefaultsService = UserDefaultsService.shared

    init() {
        checkAuthStatus()
    }

    // MARK: - Check Auth Status
    func checkAuthStatus() {
        if keychainService.hasTokens() {
            user = userDefaultsService.user
            isAuthenticated = true
        }
    }

    // MARK: - Login
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let credentials = LoginCredentials(email: email, password: password)
            let response = try await authAPI.login(credentials: credentials)

            // Save tokens to Keychain
            try keychainService.saveTokens(response.tokens)

            // Save user to UserDefaults
            userDefaultsService.user = response.user

            // Update state
            self.user = response.user
            self.isAuthenticated = true
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Register
    func register(name: String, email: String, password: String, confirmPassword: String) async {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let credentials = RegisterCredentials(
                name: name,
                email: email,
                password: password,
                confirmPassword: confirmPassword
            )
            let response = try await authAPI.register(credentials: credentials)

            // Save tokens to Keychain
            try keychainService.saveTokens(response.tokens)

            // Save user to UserDefaults
            userDefaultsService.user = response.user

            // Update state
            self.user = response.user
            self.isAuthenticated = true
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Logout
    func logout() async {
        isLoading = true

        do {
            try await authAPI.logout()
        } catch {
            // Log error but continue with local logout
            print("Logout API error: \(error)")
        }

        // Clear local data
        try? keychainService.deleteTokens()
        userDefaultsService.clearAll()

        // Update state
        self.user = nil
        self.isAuthenticated = false
        isLoading = false
    }

    // MARK: - Forgot Password
    func forgotPassword(email: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            try await authAPI.forgotPassword(email: email)
            isLoading = false
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    // MARK: - Update Profile
    func updateProfile(name: String?, avatar: String?) async {
        isLoading = true
        errorMessage = nil

        do {
            let updatedUser = try await authAPI.updateProfile(name: name, avatar: avatar)
            userDefaultsService.user = updatedUser
            self.user = updatedUser
        } catch {
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Clear Error
    func clearError() {
        errorMessage = nil
    }
}
