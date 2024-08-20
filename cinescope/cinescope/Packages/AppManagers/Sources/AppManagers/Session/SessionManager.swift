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
    public var favorites = CurrentValueSubject<[FavoriteCellContent], Error>(UserManager.shared.favorites)
    
    // MARK: - Public Methods
    public func removeFromFavorites(_ movie: FavoriteCellContent) {
        var existedFavorites = UserManager.shared.favorites
        guard existedFavorites.contains(movie) else { return }
        existedFavorites.removeAll(where: {$0.id == movie.id })
        UserManager.shared.favorites = existedFavorites
    }
    
    public func addToFavorites(_ movie: FavoriteCellContent) {
        var existedFavorites = UserManager.shared.favorites
        guard !existedFavorites.contains(movie) else { return }
        existedFavorites.append(movie)
        UserManager.shared.favorites = existedFavorites
    }
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
