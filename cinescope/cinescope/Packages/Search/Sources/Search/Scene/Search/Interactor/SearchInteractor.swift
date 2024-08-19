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
    /// Variables
    var canFetchMore: Bool { get }
    /// Functions
    func fetchDiscoveredMovies(with parameters: [String: Any]) -> AnyPublisher<[Movie]?, BaseError>
    func fetchNowPlayingMovies() -> AnyPublisher<[Movie]?, BaseError>
    func fetchPopularMovies() -> AnyPublisher<[Movie]?, BaseError>
    func fetchTopRatedMovies() -> AnyPublisher<[Movie]?, BaseError>
    func fetchUpComingMovies() -> AnyPublisher<[Movie]?, BaseError>
    func fetchSearchedMovies(with parameters: [String: Any]) -> AnyPublisher<[Movie]?, BaseError>
}

// MARK: - SearchInteractor
final class SearchInteractor: SearchInteractorProtocol {
    // MARK: - Private Variables
    private let network = NetworkManager.shared
    private var currentPage = 0
    private var totalPage = 1
    
    // MARK: - Public Variables
    var canFetchMore: Bool {
        return currentPage < totalPage
    }

    // MARK: - Functions
    final func fetchDiscoveredMovies(with parameters: [String: Any]) -> AnyPublisher<[Movie]?, BaseError> {
        return Future<[Movie]?, BaseError> { [weak self] promise in
            guard let self else { return }
            network.request(
                router: MovieAPI.getDiscoveredMovies(parameters: getPaginationParameters(for: parameters)),
                model: MovieListResponse.self
            ) { [weak self] result in
                guard let self else { return }
                handleMovieListResponse(result: result, promise: promise)
            }
        }
        .eraseToAnyPublisher()
    }
    
    final func fetchNowPlayingMovies() -> AnyPublisher<[Movie]?, BaseError> {
        return Future<[Movie]?, BaseError> { [weak self] promise in
            guard let self else { return }
            network.request(
                router: MovieAPI.getNowPlayingMovies(parameters: getPaginationParameters()),
                model: MovieListResponse.self
            ) { [weak self] result in
                guard let self else { return }
                handleMovieListResponse(result: result, promise: promise)
            }
        }
        .eraseToAnyPublisher()
    }
    
    final func fetchPopularMovies() -> AnyPublisher<[Movie]?, BaseError> {
        return Future<[Movie]?, BaseError> { [weak self] promise in
            guard let self else { return }
            network.request(
                router: MovieAPI.getPopularSearchMovies(parameters: getPaginationParameters()),
                model: MovieListResponse.self
            ) { [weak self] result in
                guard let self else { return }
                handleMovieListResponse(result: result, promise: promise)
            }
        }
        .eraseToAnyPublisher()
    }
    
    final func fetchTopRatedMovies() -> AnyPublisher<[Movie]?, BaseError> {
        return Future<[Movie]?, BaseError> { [weak self] promise in
            guard let self else { return }
            network.request(
                router: MovieAPI.getTopRatedMovies(parameters: getPaginationParameters()),
                model: MovieListResponse.self
            ) { [weak self] result in
                guard let self else { return }
                handleMovieListResponse(result: result, promise: promise)
            }
        }
        .eraseToAnyPublisher()
    }
    
    final func fetchUpComingMovies() -> AnyPublisher<[Movie]?, BaseError> {
        return Future<[Movie]?, BaseError> { [weak self] promise in
            guard let self else { return }
            network.request(
                router: MovieAPI.getUpComingMovies(parameters: getPaginationParameters()),
                model: MovieListResponse.self
            ) { [weak self] result in
                guard let self else { return }
                handleMovieListResponse(result: result, promise: promise)
            }
        }
        .eraseToAnyPublisher()
    }
    
    final func fetchSearchedMovies(with parameters: [String: Any]) -> AnyPublisher<[Movie]?, BaseError>  {
        return Future<[Movie]?, BaseError> { [weak self] promise in
            guard let self else { return }
            network.request(
                router: MovieAPI.getSearchedMovies(parameters: getPaginationParameters(for: parameters)),
                model: MovieListResponse.self
            ) { [weak self] result in
                guard let self else { return }
                handleMovieListResponse(result: result, promise: promise)
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - Helpers
private extension SearchInteractor {
    final func getPaginationParameters(
        for currentParameters: [String: Any] = [:]
    ) -> [String: Any] {
        var updatedParameters = currentParameters
        currentPage += 1
        updatedParameters["page"] = "\(currentPage)"
        
        return updatedParameters
    }
    
    final func handleMovieListResponse(
        result: Result<MovieListResponse, BaseResponseError<MovieListResponse>>,
        promise: @escaping (Result<[Movie]?, BaseError>) -> Void
    ) {
        switch result {
        case .success(let response):
            self.totalPage = response.totalPages ?? 1
            promise(.success(response.results))
        case .failure(let error):
            promise(.failure(BaseError(friendlyMessage: error.updatedFriendlyMessage)))
        }
    }
}
