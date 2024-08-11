//
//  HomeInteractor.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import AppManagers
import Combine
import Foundation
import Network

// MARK: - HomeInteractorProtocol
protocol HomeInteractorProtocol {
    /// Functions
    func fetchPopularMovies() -> AnyPublisher<[Movie]?, BaseError>
    func fetchMovieGenres() -> AnyPublisher<[Genre]?, BaseError>
}

// MARK: - HomeInteractor
final class HomeInteractor: HomeInteractorProtocol {
    // MARK: - Private Variables
    private let network = NetworkManager.shared

    // MARK: - Functions
    func fetchPopularMovies() -> AnyPublisher<[Movie]?, BaseError> {
        return Future<[Movie]?, BaseError> { [weak self] promise in
            guard let self else { return }
            self.network.request(
                router: MovieAPI.getPopularMovies,
                model: MovieListResponse.self
            ) { result in
                switch result {
                case .success(let response):
                    promise(.success(response.results))
                case .failure(let error):
                    promise(.failure(BaseError(friendlyMessage: error.updatedFriendlyMessage)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchMovieGenres() -> AnyPublisher<[Genre]?, BaseError> {
        return Future<[Genre]?, BaseError> { [weak self] promise in
            guard let self else { return }
            self.network.request(
                router: MovieAPI.getMovieGenreList,
                model: GenreListResponse.self
            ) { result in
                switch result {
                case .success(let response):
                    promise(.success(response.genres))
                case .failure(let error):
                    promise(.failure(BaseError(friendlyMessage: error.updatedFriendlyMessage)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
