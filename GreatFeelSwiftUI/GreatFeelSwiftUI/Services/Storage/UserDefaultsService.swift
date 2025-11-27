//
//  UserDefaultsService.swift
//  GreatFeelSwiftUI
//
//  User preferences storage using UserDefaults
//

import Foundation

class UserDefaultsService {
    static let shared = UserDefaultsService()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let themeMode = "themeMode"
        static let selectedMood = "selectedMood"
        static let isAudioMuted = "isAudioMuted"
        static let user = "user"
    }

    private init() {}

    // MARK: - Theme Mode
    var themeMode: ThemeMode {
        get {
            guard let rawValue = defaults.string(forKey: Keys.themeMode),
                  let mode = ThemeMode(rawValue: rawValue) else {
                return .auto
            }
            return mode
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.themeMode)
        }
    }

    // MARK: - Selected Mood
    var selectedMood: Mood {
        get {
            guard let rawValue = defaults.string(forKey: Keys.selectedMood),
                  let mood = Mood(rawValue: rawValue) else {
                return .calm
            }
            return mood
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.selectedMood)
        }
    }

    // MARK: - Audio Muted
    var isAudioMuted: Bool {
        get {
            defaults.bool(forKey: Keys.isAudioMuted)
        }
        set {
            defaults.set(newValue, forKey: Keys.isAudioMuted)
        }
    }

    // MARK: - User
    var user: User? {
        get {
            guard let data = defaults.data(forKey: Keys.user) else {
                return nil
            }
            return try? JSONDecoder().decode(User.self, from: data)
        }
        set {
            if let user = newValue {
                let data = try? JSONEncoder().encode(user)
                defaults.set(data, forKey: Keys.user)
            } else {
                defaults.removeObject(forKey: Keys.user)
            }
        }
    }

    // MARK: - Clear All
    func clearAll() {
        defaults.removeObject(forKey: Keys.themeMode)
        defaults.removeObject(forKey: Keys.selectedMood)
        defaults.removeObject(forKey: Keys.isAudioMuted)
        defaults.removeObject(forKey: Keys.user)
    }
}
