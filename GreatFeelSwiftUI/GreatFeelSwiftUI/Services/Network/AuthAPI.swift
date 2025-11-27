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
        // For now, return mock data for testing
        // In production, uncomment the real API call

        // Real API call:
        // return try await client.request(
        //     endpoint: "/auth/login",
        //     method: .post,
        //     body: credentials,
        //     requiresAuth: false
        // )

        // Mock response for testing
        try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate network delay

        let mockTokens = AuthTokens(
            accessToken: "mock_access_token_\(UUID().uuidString)",
            refreshToken: "mock_refresh_token_\(UUID().uuidString)",
            expiresIn: 3600
        )

        return AuthResponse(user: User.mock, tokens: mockTokens)
    }

    // MARK: - Register
    func register(credentials: RegisterCredentials) async throws -> AuthResponse {
        return try await client.request(
            endpoint: "/auth/register",
            method: .post,
            body: credentials,
            requiresAuth: false
        )
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
