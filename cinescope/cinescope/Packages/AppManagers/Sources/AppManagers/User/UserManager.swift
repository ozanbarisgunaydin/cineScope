//
//  UserManager.swift
//
//
//  Created by Ozan Barış Günaydın on 4.01.2024.
//

import AppResources
import Database
import UIKit

// MARK: - UserManager
public class UserManager: UserManagerProtocol {
    // MARK: - Shared
    public static var shared = UserManager()

    // MARK: - Data
    private let userDefaults = UserDefaults.standard

    // MARK: - Init
    private init() { }

    // MARK: - App General
    public var lastDiscoveredMovieID: String? {
        get { userDefaults.lastDiscoveredMovieID }
        set { userDefaults.lastDiscoveredMovieID = newValue }
    }
}

// MARK: - UserDefaults
private extension UserDefaults {
    private enum Keys {
        static let lastDiscoveredMovieID: String = "lastDiscoveredMovieID"
    }
    
    var lastDiscoveredMovieID: String? {
        get {
            return read(String.self, with: Keys.lastDiscoveredMovieID)
        }
        set {
            save(item: newValue, forKey: Keys.lastDiscoveredMovieID)
        }
    }
}
