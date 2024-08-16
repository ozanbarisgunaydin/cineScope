//
//  SearchInteractor.swift
//
//
//  Created by Ozan Barış Günaydın on 16.08.2024.
//

import AppManagers
import Combine
import Foundation
import Network

// MARK: - SearchInteractorProtocol
protocol SearchInteractorProtocol {
    /// Functions
    func fetchDiscoveredMovies(with parameters: [String: Any]) -> AnyPublisher<[Movie]?, BaseError>
}

// MARK: - SearchInteractor
final class SearchInteractor: SearchInteractorProtocol {
    // MARK: - Private Variables
    private let network = NetworkManager.shared
    
    // MARK: - Functions
    func fetchDiscoveredMovies(with parameters: [String: Any]) -> AnyPublisher<[Movie]?, BaseError> {
        return Future<[Movie]?, BaseError> { [weak self] promise in
            guard let self else { return }
            self.network.request(
                router: MovieAPI.getDiscoveredMovies(parameters: parameters),
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
}
