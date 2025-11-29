//
//  AuthAPI.swift
//  GreatFeelSwiftUI
//
//  Authentication API endpoints
//

import Foundation

class AuthAPI {
    private let client = APIClient.shared

    // MARK: - Login
    func login(credentials: LoginCredentials) async throws -> AuthResponse {
        // HARDCODED LOGIN FOR DEVELOPMENT
        // TODO: Replace with real API call when backend is ready
        // Endpoint: POST /auth/login
        // Request: { email, password }
        // Response: { user, tokens }

        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay

        // Validate hardcoded credentials
        if credentials.email.lowercased() == "admin" && credentials.password == "admin" {
            let mockTokens = AuthTokens(
                accessToken: "mock_access_token_\(UUID().uuidString)",
                refreshToken: "mock_refresh_token_\(UUID().uuidString)",
                expiresIn: 3600
            )

            // Create admin user
            let adminUser = User(
                id: UUID().uuidString,
                name: "Admin User",
                email: "admin@greatfeel.com",
                avatar: nil,
                createdAt: Date(),
                updatedAt: Date()
            )

            return AuthResponse(user: adminUser, tokens: mockTokens)
        } else {
            throw AuthError.invalidCredentials
        }

        // Real API call (commented out for now):
        // return try await client.request(
        //     endpoint: "/auth/login",
        //     method: .post,
        //     body: credentials,
        //     requiresAuth: false
        // )
    }

    // MARK: - Register
    func register(credentials: RegisterCredentials) async throws -> AuthResponse {
        // HARDCODED REGISTRATION FOR DEVELOPMENT
        // TODO: Replace with real API call when backend is ready
        // Endpoint: POST /auth/register
        // Request: { email, password, full_name }
        // Response: { user, tokens }

        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay

        // Basic validation
        guard credentials.password == credentials.confirmPassword else {
            throw AuthError.passwordMismatch
        }

        guard credentials.password.count >= 6 else {
            throw AuthError.weakPassword
        }

        // Create mock user from registration data
        let mockTokens = AuthTokens(
            accessToken: "mock_access_token_\(UUID().uuidString)",
            refreshToken: "mock_refresh_token_\(UUID().uuidString)",
            expiresIn: 3600
        )

        let newUser = User(
            id: UUID().uuidString,
            name: credentials.name,
            email: credentials.email,
            avatar: nil,
            createdAt: Date(),
            updatedAt: Date()
        )

        return AuthResponse(user: newUser, tokens: mockTokens)

        // Real API call (commented out for now):
        // return try await client.request(
        //     endpoint: "/auth/register",
        //     method: .post,
        //     body: credentials,
        //     requiresAuth: false
        // )
    }

    // MARK: - Logout
    func logout() async throws {
        try await client.requestWithoutResponse(
            endpoint: "/auth/logout",
            method: .post,
            requiresAuth: true
        )
    }

    // MARK: - Forgot Password
    func forgotPassword(email: String) async throws {
        try await client.requestWithoutResponse(
            endpoint: "/auth/forgot-password",
            method: .post,
            body: ForgotPasswordRequest(email: email),
            requiresAuth: false
        )
    }

    // MARK: - Reset Password
    func resetPassword(request: ResetPasswordRequest) async throws {
        try await client.requestWithoutResponse(
            endpoint: "/auth/reset-password",
            method: .post,
            body: request,
            requiresAuth: false
        )
    }

    // MARK: - Get Current User
    func getCurrentUser() async throws -> User {
        return try await client.request(
            endpoint: "/auth/me",
            method: .get,
            requiresAuth: true
        )
    }

    // MARK: - Update Profile
    func updateProfile(name: String?, avatar: String?) async throws -> User {
        struct UpdateProfileRequest: Codable {
            let name: String?
            let avatar: String?
        }

        return try await client.request(
            endpoint: "/auth/profile",
            method: .patch,
            body: UpdateProfileRequest(name: name, avatar: avatar),
            requiresAuth: true
        )
    }
}
