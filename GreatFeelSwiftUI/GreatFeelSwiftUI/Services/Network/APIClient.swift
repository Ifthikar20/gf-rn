//
//  APIClient.swift
//  GreatFeelSwiftUI
//
//  Network client with token refresh and error handling
//

import Foundation

class APIClient {
    static let shared = APIClient()

    private let baseURL: String
    private let session: URLSession
    private let keychainService = KeychainService.shared

    private var isRefreshing = false
    private var refreshCompletions: [(Result<AuthTokens, Error>) -> Void] = []

    private init() {
        #if DEBUG
        self.baseURL = "http://localhost:3000/api"
        #else
        self.baseURL = "https://api.greatfeel.com/api"
        #endif

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: configuration)
    }

    // MARK: - Request Method
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil,
        requiresAuth: Bool = true
    ) async throws -> T {
        var request = try createRequest(endpoint: endpoint, method: method, body: body)

        // Add auth token if required
        if requiresAuth {
            if let tokens = try? keychainService.getTokens() {
                request.addValue("Bearer \(tokens.accessToken)", forHTTPHeaderField: "Authorization")
            }
        }

        do {
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            return try JSONDecoder.customDecoder.decode(T.self, from: data)
        } catch let error as NetworkError where error == .unauthorized {
            // Token expired, try to refresh
            if requiresAuth {
                let tokens = try await refreshToken()
                request.setValue("Bearer \(tokens.accessToken)", forHTTPHeaderField: "Authorization")

                // Retry original request
                let (data, response) = try await session.data(for: request)
                try validateResponse(response)
                return try JSONDecoder.customDecoder.decode(T.self, from: data)
            } else {
                throw error
            }
        }
    }

    // MARK: - Request Without Response Body
    func requestWithoutResponse(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil,
        requiresAuth: Bool = true
    ) async throws {
        var request = try createRequest(endpoint: endpoint, method: method, body: body)

        if requiresAuth {
            if let tokens = try? keychainService.getTokens() {
                request.addValue("Bearer \(tokens.accessToken)", forHTTPHeaderField: "Authorization")
            }
        }

        let (_, response) = try await session.data(for: request)
        try validateResponse(response)
    }

    // MARK: - Token Refresh
    private func refreshToken() async throws -> AuthTokens {
        // Check if already refreshing
        if isRefreshing {
            return try await withCheckedThrowingContinuation { continuation in
                refreshCompletions.append { result in
                    continuation.resume(with: result)
                }
            }
        }

        isRefreshing = true
        defer { isRefreshing = false }

        do {
            guard let currentTokens = try? keychainService.getTokens() else {
                throw NetworkError.unauthorized
            }

            let request = try createRequest(
                endpoint: "/auth/refresh",
                method: .post,
                body: ["refreshToken": currentTokens.refreshToken]
            )

            let (data, response) = try await session.data(for: request)
            try validateResponse(response)

            let authResponse = try JSONDecoder.customDecoder.decode(AuthResponse.self, from: data)
            try keychainService.saveTokens(authResponse.tokens)

            // Complete all waiting requests
            refreshCompletions.forEach { $0(.success(authResponse.tokens)) }
            refreshCompletions.removeAll()

            return authResponse.tokens
        } catch {
            // Refresh failed, clear tokens and complete waiting requests
            try? keychainService.deleteTokens()
            refreshCompletions.forEach { $0(.failure(error)) }
            refreshCompletions.removeAll()
            throw error
        }
    }

    // MARK: - Helper Methods
    private func createRequest(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable?
    ) throws -> URLRequest {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = try JSONEncoder.customEncoder.encode(body)
        }

        return request
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw NetworkError.unauthorized
        case 400...499:
            throw NetworkError.clientError(httpResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.unknown
        }
    }
}

// MARK: - HTTP Method
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - Network Error
enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case unauthorized
    case clientError(Int)
    case serverError(Int)
    case decodingError
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .clientError(let code):
            return "Client error: \(code)"
        case .serverError(let code):
            return "Server error: \(code)"
        case .decodingError:
            return "Failed to decode response"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

// MARK: - JSON Coding Extensions
extension JSONDecoder {
    static var customDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }
}

extension JSONEncoder {
    static var customEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .useDefaultKeys
        return encoder
    }
}
