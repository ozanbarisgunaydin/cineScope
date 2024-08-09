//
// SessionManager.swift
// OBG
//
// Created by Ozan Barış Günaydın on 4.01.2024.
//

import Foundation
import Combine
import AppResources

// MARK: - SessionManager
public class SessionManager: SessionManagerProtocol {
    // MARK: - Shared
    public static var shared = SessionManager()

    // MARK: - Private Variables
    private var cancellables: [AnyCancellable] = []
    private var timer: Timer?
    private var initialServerDate: Date?

    // MARK: - Init
    private init() { }

    // MARK: - Publics Variables

    // MARK: - Public Functions
    public func clear() {
    }
 }
