//
//  UserManager.swift
//
//
//  Created by Ozan Barış Günaydın on 4.01.2024.
//

import UIKit
import AppResources

// MARK: - UserManager
public class UserManager: UserManagerProtocol {
    // MARK: - Shared
    public static var shared = UserManager()

    // MARK: - Data
    private let userDefaults = UserDefaults.standard
    private let session = SessionManager.shared

    // MARK: - Init
    private init() { }

    // MARK: - App General
    public var isInDarkTheme: Bool {
        get { userDefaults.isInDarkTheme }
        set {
            userDefaults.isInDarkTheme = newValue
            overrideApplicationThemeStyle()
        }
    }
}

// MARK: - Helpers
private extension UserManager {
    final func overrideApplicationThemeStyle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
        window.overrideUserInterfaceStyle = UserManager.shared.isInDarkTheme ? .dark : .light
    }
}

// MARK: - UserDefaults
private extension UserDefaults {
    private enum Keys {
        static let isInDarkTheme: String = "isInDarkTheme"
    }

    var isInDarkTheme: Bool {
        get {
            return read(Bool.self, with: Keys.isInDarkTheme) ?? false
        }
        set {
            save(item: newValue, forKey: Keys.isInDarkTheme)
        }
    }
}
