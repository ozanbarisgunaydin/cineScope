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
    var bannerPublisher: Published<[BannerContent]>.Publisher { get }
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
    @Published var banners: [BannerContent] = []
    var bannerPublisher: Published<[BannerContent]>.Publisher { $banners }
    @Published var content: [HomeContent] = []
    var contentPublisher: Published<[HomeContent]>.Publisher { $content }
}

// MARK: - Publics
extension HomePresenter {
    final func fetchContent() {
        fetchPopularMovies()
        fetchMovieGenreList()
        fetchPeopleList()
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
        banners = movieList.compactMap { movie in
            return BannerContent(
                title: movie.originalTitle,
                imageURL: "\(NetworkingConstants.BaseURL.image)\(movie.backdropPath ?? "")"
            )
        }
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
    
    final func fetchPeopleList() {
        isLoading.send(true)
        interactor.fetchPeopleList().sink(receiveCompletion: { [weak self] completion in
            guard let self else { return }
            switch completion {
            case .finished:
                isLoading.send(false)
            case .failure(let error):
                showServiceFailure(errorMessage: error.friendlyMessage)
            }
        }, receiveValue: { [weak self] people in
            guard let self else { return }
            preparePersonContent(with: people)
        })
        .store(in: &cancellables)
    }
    
    final func preparePersonContent(with peopleList: [PeopleContent]?) {
        let items: [HomeItemType] = peopleList?.compactMap { people in
            let personContent = PersonContent(
                artistName: people.name,
                profileImageURL: "\(NetworkingConstants.BaseURL.image)\(people.profilePath ?? "")",
                knownedMoviePosters: people.knownFor?.compactMap {
                    "\(NetworkingConstants.BaseURL.image)\($0.backdropPath ?? "")"
                } ?? []
            )
            return HomeItemType.person(cellContent: personContent)
        } ?? []
        
        let personContent = HomeContent(
            sectionType: .reviews(headerTitle: L10nHome.celebrities.localized()),
            items: items
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            content.append(personContent)
        }
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
