//
//  SearchTabInteractor.swift
//
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import AppManagers
import Combine
import Foundation
import Network

// MARK: - SearchTabInteractorProtocol
protocol SearchTabInteractorProtocol {
    /// Functions
    func fetchKeywords() -> AnyPublisher<[String]?, BaseError>
}

// MARK: - SearchTabInteractor
final class SearchTabInteractor: SearchTabInteractorProtocol {
    // MARK: - Private Variables
    private let network = NetworkManager.shared
    
    // MARK: - Functions
    final func fetchKeywords() -> AnyPublisher<[String]?, BaseError> {
        return Future<[String]?, BaseError> { [weak self] promise in
            guard let self else { return }
            self.network.request(
                router: MovieAPI.getLastMovieKeywords,
                model: MovieKeywordListEntity.self
            ) { result in
                switch result {
                case .success(let response):
                    promise(.success(response.keywords?.compactMap({ $0.name })))
                case .failure(let error):
                    promise(.failure(BaseError(friendlyMessage: error.updatedFriendlyMessage)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}
