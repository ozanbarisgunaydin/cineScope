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
}
