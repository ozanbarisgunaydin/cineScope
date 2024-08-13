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
    var bannerPublisher: Published<[BannerContent]>.Publisher { get }
    var contentPublisher: Published<[HomeContent]>.Publisher { get }

    /// Functions
    func fetchContent()
    func getSectionProperties(for index: Int) -> (type: HomeSectionType, itemCount: Int)?
    func routeToMovieDetail(for movieID: Int)
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
    
    // MARK: - Published Variables
    @Published var banners: [BannerContent] = []
    var bannerPublisher: Published<[BannerContent]>.Publisher { $banners }
    @Published var content: [HomeContent] = []
    var contentPublisher: Published<[HomeContent]>.Publisher { $content }
    
    // MARK: - Privates
    private var contentWorkItem: DispatchWorkItem?
    
    // MARK: - Init
    init(
        view: HomeViewProtocol,
        interactor: HomeInteractorProtocol,
        router: HomeRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Publics
extension HomePresenter {
    final func fetchContent() {
        isLoading.send(true)
        
        let popularMoviesPublisher = interactor.fetchPopularMovies()
            .catch { [weak self] error -> Just<[Movie]?> in
                guard let self else { return Just(nil)}
                showServiceFailure(errorMessage: error.friendlyMessage)
                return Just(nil)
            }
            .eraseToAnyPublisher()
        
        let genresPublisher = interactor.fetchMovieGenres()
            .catch { [weak self] error -> Just<[Genre]?> in
                guard let self else { return Just(nil) }
                showServiceFailure(errorMessage: error.friendlyMessage)
                return Just(nil)
            }
            .eraseToAnyPublisher()
        
        let peopleListPublisher = interactor.fetchPeopleList()
            .catch { [weak self] error -> Just<[PeopleContent]?> in
                guard let self else { return Just(nil) }
                showServiceFailure(errorMessage: error.friendlyMessage)
                return Just(nil)
            }
            .eraseToAnyPublisher()
        
        Publishers.Zip3(popularMoviesPublisher, genresPublisher, peopleListPublisher)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                isLoading.send(false)
            }, receiveValue: { [weak self] popularMovies, genres, peopleList in
                guard let self else { return }
                setMoviesPosterPaths(with: popularMovies)
                prepareCollectionContent(
                    genres: genres,
                    peopleList: peopleList
                )
            })
            .store(in: &cancellables)
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
    
    final func routeToMovieDetail(for movieID: Int) {
        router.navigate(.detail(id: movieID))
    }
}

// MARK: - Helpers
private extension HomePresenter {
    final func setMoviesPosterPaths(with movieList: [Movie]?)  {
        guard let movieList,
              !movieList.isEmpty else { return }
        banners = movieList.compactMap { movie in
            return BannerContent(
                title: movie.title,
                imageURL: movie.backDropImageURL,
                movieID: movie.id
            )
        }
    }
    
    final func prepareCollectionContent(
        genres: [Genre]?,
        peopleList: [PeopleContent]?
    ) {
        var temporaryContent: [HomeContent] = []
        if let preparedGenres = getGenreContent(with: genres) {
            temporaryContent.append(preparedGenres)
        }
        
        temporaryContent.append(getCategoryContent())
        
        if let preparedPeoples = getPersonContent(with: peopleList) {
            temporaryContent.append(preparedPeoples)
        }
        
        content = temporaryContent
    }
    
    final func getGenreContent(with movieGenres: [Genre]?) -> HomeContent? {
        let genreItems: [HomeItemType] = (movieGenres ?? []).compactMap { genre in
                .genre(cellContent: genre.name ?? .unknown)
        }
        
        guard !genreItems.isEmpty else { return nil }
        return HomeContent(
            sectionType: .genreList(headerTitle: L10nHome.genres.localized()),
            items: genreItems
        )
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
    
    final func getPersonContent(with peopleList: [PeopleContent]?) -> HomeContent? {
        let items: [HomeItemType] = peopleList?.compactMap { people in
            let personContent = PersonContent(
                artistName: people.name,
                profileImageURL: people.profileImageURL,
                knownedMoviePosters: people.knownFor?.compactMap { $0.backDropImageURL } ?? []
            )
            return HomeItemType.person(cellContent: personContent)
        } ?? []
        
        guard !items.isEmpty else { return nil }
        return HomeContent(
            sectionType: .reviews(headerTitle: L10nHome.celebrities.localized()),
            items: items
        )
    }
}
