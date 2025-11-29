//
//  User.swift
//  GreatFeelSwiftUI
//
//  User and authentication models
//

import Foundation

// MARK: - User
struct User: Codable, Identifiable {
    let id: String
    let email: String
    let name: String
    let avatar: String?
    let createdAt: Date?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, email, name, avatar, createdAt, updatedAt
    }
}

// MARK: - Auth Tokens
struct AuthTokens: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken, expiresIn
    }
}

// MARK: - Login Credentials
struct LoginCredentials: Codable {
    let email: String
    let password: String
}

// MARK: - Register Credentials
struct RegisterCredentials: Codable {
    let name: String
    let email: String
    let password: String
    let confirmPassword: String
}

// MARK: - Forgot Password Request
struct ForgotPasswordRequest: Codable {
    let email: String
}

// MARK: - Reset Password Request
struct ResetPasswordRequest: Codable {
    let token: String
    let password: String
    let confirmPassword: String
}

// MARK: - Auth Response
struct AuthResponse: Codable {
    let user: User
    let tokens: AuthTokens
}

// MARK: - Auth Errors
enum AuthError: LocalizedError {
    case invalidCredentials
    case passwordMismatch
    case weakPassword
    case emailAlreadyExists
    case networkError
    case serverError
    case invalidToken
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password. Please try again."
        case .passwordMismatch:
            return "Passwords do not match."
        case .weakPassword:
            return "Password must be at least 6 characters long."
        case .emailAlreadyExists:
            return "An account with this email already exists."
        case .networkError:
            return "Network error. Please check your connection."
        case .serverError:
            return "Server error. Please try again later."
        case .invalidToken:
            return "Session expired. Please log in again."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

// MARK: - Mock User for Testing
extension User {
    static let mock = User(
        id: "1",
        email: "user@greatfeel.com",
        name: "John Doe",
        avatar: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400",
        createdAt: Date(),
        updatedAt: Date()
    )
}
