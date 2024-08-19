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
    /// Variables
    var bannerPublisher: Published<[BannerContent]>.Publisher { get }
    var contentPublisher: Published<[HomeContent]>.Publisher { get }
    /// Functions
    func fetchContent()
    func getSectionProperties(for index: Int) -> (type: HomeSectionType, itemCount: Int)?
    func routeToMovieDetail(for movieID: Int)
    func routeToGenreSearch(on index: Int)
    func routeToCategorySearch(on type: CategoryType)
    func routeToPeopleSearch(on index: Int)
}

// MARK: - HomePresenter
final class HomePresenter: BasePresenter, HomePresenterProtocol {
    // MARK: - Components
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol
    
    // MARK: - Published Variables
    @Published var banners: [BannerContent] = []
    var bannerPublisher: Published<[BannerContent]>.Publisher { $banners }
    @Published var content: [HomeContent] = []
    var contentPublisher: Published<[HomeContent]>.Publisher { $content }
    
    // MARK: - Privates
    private var contentWorkItem: DispatchWorkItem?
    private var genres: [Genre]?
    private var peopleList: [PeopleContent]?
    
    // MARK: - Init
    init(
        view: HomeViewProtocol,
        interactor: HomeInteractorProtocol,
        router: BaseRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        super.init(router: router)
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
        router?.navigate(.detail(id: movieID))
    }
    
    final func routeToGenreSearch(on index: Int) {
        guard let genre = genres?[safe: index],
              let genreID = genre.id else { return }
        router?.navigate(
            .search(
                type: .genres(
                    content: NonQuerySearh(
                        id: "\(genreID)",
                        title: genre.name
                    )
                )
            )
        )
    }
    
    final func routeToCategorySearch(on type: CategoryType) {
        let searchType: SearchType = switch type {
        case .nowPlaying:
                .nowPlaying
        case .popular:
                .popular
        case .topRated:
                .topRated
        case .upComing:
                .upComing
        }
        router?.navigate(.search(type: searchType))
    }
    
    final func routeToPeopleSearch(on index: Int) {
        guard let person = peopleList?[safe: index],
              let personID = person.id else { return }
        router?.navigate(
            .search(
                type: .people(
                    content: NonQuerySearh(
                        id: "\(personID)",
                        title: person.name
                    )
                )
            )
        )
    }
}

// MARK: - Helpers
private extension HomePresenter {
    final func setMoviesPosterPaths(with movieList: [Movie]?)  {
        guard let movieList,
              !movieList.isEmpty,
              let firstID = movieList.first?.id else { return }
        SessionManager.shared.lastDiscoveredMovieID.send("\(firstID)")
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
        self.genres = genres
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
        let homeTypeGenreList: [HomeGenre] = (movieGenres ?? []).compactMap { genre in
            return HomeGenre(id: genre.id, name: HomeGenreType(rawValue: genre.name ?? ""))
        }
        let genreItems: [HomeItemType] = homeTypeGenreList.compactMap { genre in
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
        self.peopleList = peopleList
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
