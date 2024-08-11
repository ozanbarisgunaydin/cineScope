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
import UIKit

// MARK: - HomePresenterProtocol
protocol HomePresenterProtocol: BasePresenterProtocol {
    /// Components
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorProtocol { get set }
    var router: HomeRouterProtocol { get set }
    /// Variables
    var bannerPublisher: Published<[String]>.Publisher { get }
    var contentPublisher: Published<[HomeContent]>.Publisher { get }

    /// Functions
    func fetchContent()
    func getSectionProperties(for index: Int) -> (type: HomeSectionType, itemCount: Int)?
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

    // MARK: - Published Variables
    @Published var banners: [String] = []
    var bannerPublisher: Published<[String]>.Publisher { $banners }
    @Published var content: [HomeContent] = []
    var contentPublisher: Published<[HomeContent]>.Publisher { $content }
}

// MARK: - Publics
extension HomePresenter {
    final func fetchContent() {
        fetchPopularMovies()
        fetchMovieGenreList()
    }
    
    
    final func getSectionProperties(
        for index: Int
    ) -> (type: HomeSectionType, itemCount: Int)? {
        guard let section = content[safe: index] else { return nil }
        return (
            type: section.sectionType,
            itemCount: section.items.count
        )
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
            prepareContent(with: movieGenres)
        })
        .store(in: &cancellables)
    }
    
    final func prepareContent(with movieGenres: [Genre]?) {
        let genreItems: [HomeItemType] = (movieGenres ?? []).compactMap{ genre in
                .genre(
                    cellContent: genre.name ?? .unknown
                )
        }
        let preparedContent = [
            HomeContent(
                sectionType: .genreList(headerTitle: L10nHome.genres.localized()),
                items: genreItems
            ),
            getCategoryContent()
        ]
        
        content = preparedContent
    }
    
    final func getCategoryContent() -> HomeContent {
        return HomeContent(
            sectionType: .categories(
                headerTitle: L10nHome.discover.localized()
            ),
            items: [
                .category(cellContent: .nowPlaying),
                .category(cellContent: .topRated),
                .category(cellContent: .upComing),
                .category(cellContent: .popular)
            ]
        )
    }
}
