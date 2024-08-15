//
//  DetailInteractor.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import AppManagers
import Combine
import Foundation
import Network

// MARK: - DetailInteractorProtocol
protocol DetailInteractorProtocol {
    /// Functions
    func fetchMovieDetail(with movieID: Int) -> AnyPublisher<Movie, BaseError>
    func fetchSimilarMovies(with movieID: Int) -> AnyPublisher<[Movie]?, BaseError>
}

// MARK: - DetailInteractor
final class DetailInteractor: DetailInteractorProtocol {
    // MARK: - Private Variables
    private let network = NetworkManager.shared
    
    // MARK: - Functions
    func fetchMovieDetail(with movieID: Int) -> AnyPublisher<Movie, BaseError> {
        return Future<Movie, BaseError> { [weak self] promise in
            guard let self else { return }
            self.network.request(
                router: MovieAPI.getDetail(movieID: movieID),
                model: Movie.self
            ) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(BaseError(friendlyMessage: error.updatedFriendlyMessage)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchSimilarMovies(with movieID: Int) -> AnyPublisher<[Movie]?, BaseError> {
        return Future<[Movie]?, BaseError> { [weak self] promise in
            guard let self else { return }
            self.network.request(
                router: MovieAPI.getSimilarMovies(movieID: movieID),
                model: BaseListResponse<[Movie]>.self
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
}
