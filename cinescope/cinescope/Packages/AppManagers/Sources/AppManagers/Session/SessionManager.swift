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

    // MARK: - Init
    private init() {
        observeLastDiscoveredMovieID()
    }

    // MARK: - Publics Variables
    public var lastDiscoveredMovieID = CurrentValueSubject<String?, Error>(nil)
 }

// MARK: - Helpers
private extension SessionManager {
    final func observeLastDiscoveredMovieID() {
        lastDiscoveredMovieID
            .sink { _ in } receiveValue: { movieID in
                UserManager.shared.lastDiscoveredMovieID = movieID
            }
            .store(in: &cancellables)
    }
}
