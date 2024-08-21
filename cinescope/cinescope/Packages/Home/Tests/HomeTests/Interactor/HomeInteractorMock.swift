//
//  HomeInteractorMock.swift
//
//
//  Created by Ozan Barış Günaydın on 21.08.2024.
//

import AppManagers
import Combine
import Components
import Foundation
import Network
@testable import Home

class HomeInteractorMock: HomeInteractorProtocol {
    var fetchPopularMoviesResult: Result<[Movie]?, BaseError>?
    var fetchMovieGenresResult: Result<[Genre]?, BaseError>?
    var fetchPeopleListResult: Result<[PeopleContent]?, BaseError>?
    
    func fetchPopularMovies() -> AnyPublisher<[Movie]?, BaseError> {
        return Future<[Movie]?, BaseError> { promise in
            if let result = self.fetchPopularMoviesResult {
                switch result {
                case .success(let movies):
                    promise(.success(movies))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchMovieGenres() -> AnyPublisher<[Genre]?, BaseError> {
        return Future<[Genre]?, BaseError> { promise in
            if let result = self.fetchMovieGenresResult {
                switch result {
                case .success(let genres):
                    promise(.success(genres))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchPeopleList() -> AnyPublisher<[PeopleContent]?, BaseError> {
        return Future<[PeopleContent]?, BaseError> { promise in
            if let result = self.fetchPeopleListResult {
                switch result {
                case .success(let people):
                    promise(.success(people))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
