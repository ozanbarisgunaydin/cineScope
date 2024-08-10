//
//  HomePresenter.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import AppManagers
import Combine
import Components
import Foundation

// MARK: - HomePresenterProtocol
protocol HomePresenterProtocol: BasePresenterProtocol {
    /// Components
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorProtocol { get set }
    var router: HomeRouterProtocol { get set }
    /// Variables
    var bannerPublisher: Published<[String]>.Publisher { get }
    /// Functions
    func fetchContent()
}

// MARK: - HomePresenter
final class HomePresenter: HomePresenterProtocol {
    // MARK: - Base Variables
    public var isLoading = PassthroughSubject<Bool, Error>()
    public var alert = PassthroughSubject<AlertContent?, Error>()
    public var cancellables: [AnyCancellable] = []
    
    // MARK: - Components
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol
    var router: HomeRouterProtocol
    
    init(
        view: HomeViewProtocol,
        interactor: HomeInteractorProtocol,
        router: HomeRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Private Variables
    private var movieGenreList: [Genre]?

    // MARK: - Published Variables
    @Published var banners: [String] = []
    var bannerPublisher: Published<[String]>.Publisher { $banners }
}

// MARK: - Publics
extension HomePresenter {
    final func fetchContent() {
        fetchPopularMovies()
        fetchMovieGenreList()
    }
}

// MARK: - Helpers
private extension HomePresenter {
    final func fetchPopularMovies() {
        isLoading.send(true)
        interactor.fetchPopularMovies().sink(receiveCompletion: { [weak self] completion in
            guard let self else { return }
            switch completion {
            case .finished:
                isLoading.send(false)
            case .failure(let error):
                showServiceFailure(errorMessage: error.friendlyMessage)
            }
        }, receiveValue: { [weak self] popularMovies in
            guard let self else { return }
            setMoviesPosterPaths(with: popularMovies)
        })
        .store(in: &cancellables)
    }
    
    final func setMoviesPosterPaths(with movieList: [Movie]?)  {
        guard let movieList,
              !movieList.isEmpty else { return }
        let bannerPathList = movieList.compactMap { $0.backdropPath }
        guard !bannerPathList.isEmpty else { return }
        banners = bannerPathList.map { "\(NetworkingConstants.BaseURL.image)\($0)" }
    }
    
    final func fetchMovieGenreList() {
        isLoading.send(true)
        interactor.fetchMovieGenres().sink(receiveCompletion: { [weak self] completion in
            guard let self else { return }
            switch completion {
            case .finished:
                isLoading.send(false)
            case .failure(let error):
                showServiceFailure(errorMessage: error.friendlyMessage)
            }
        }, receiveValue: { [weak self] movieGenres in
            guard let self else { return }
            movieGenreList = movieGenres
        })
        .store(in: &cancellables)
    }
}
