//
//  KeychainService.swift
//  GreatFeelSwiftUI
//
//  Secure token storage using iOS Keychain
//

import Foundation
import Security

class KeychainService {
    static let shared = KeychainService()

    private let service = "com.greatfeel.tokens"
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"

    private init() {}

    // MARK: - Save Tokens
    func saveTokens(_ tokens: AuthTokens) throws {
        try saveToken(tokens.accessToken, for: accessTokenKey)
        try saveToken(tokens.refreshToken, for: refreshTokenKey)
    }

    // MARK: - Get Tokens
    func getTokens() throws -> AuthTokens? {
        guard let accessToken = try getToken(for: accessTokenKey),
              let refreshToken = try getToken(for: refreshTokenKey) else {
            return nil
        }

        return AuthTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresIn: nil
        )
    }

    // MARK: - Delete Tokens
    func deleteTokens() throws {
        try deleteToken(for: accessTokenKey)
        try deleteToken(for: refreshTokenKey)
    }

    // MARK: - Check if Tokens Exist
    func hasTokens() -> Bool {
        do {
            return try getTokens() != nil
        } catch {
            return false
        }
    }

    // MARK: - Private Helpers

    private func saveToken(_ token: String, for key: String) throws {
        let data = Data(token.utf8)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        // Delete any existing item
        SecItemDelete(query as CFDictionary)

        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }

    private func getToken(for key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeychainError.loadFailed(status)
        }

        guard let data = result as? Data,
              let token = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }

        return token
    }

    private func deleteToken(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
}

// MARK: - Keychain Error
enum KeychainError: LocalizedError {
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)
    case deleteFailed(OSStatus)
    case invalidData

    var errorDescription: String? {
        switch self {
        case .saveFailed(let status):
            return "Failed to save to Keychain (status: \(status))"
        case .loadFailed(let status):
            return "Failed to load from Keychain (status: \(status))"
        case .deleteFailed(let status):
            return "Failed to delete from Keychain (status: \(status))"
        case .invalidData:
            return "Invalid data in Keychain"
        }
    }
}
