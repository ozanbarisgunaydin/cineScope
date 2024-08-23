//
//  HomePresenter.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import AppManagers
import AppResources
import Combine
import Components
import Foundation

// MARK: - HomePresenterProtocol
protocol HomePresenterProtocol: BasePresenterProtocol {
    /// Components
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorProtocol { get set }
    /// Variables
    var bannerPublisher: Published<[BannerContentModel]>.Publisher { get }
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
    @Published var banners: [BannerContentModel] = []
    var bannerPublisher: Published<[BannerContentModel]>.Publisher { $banners }
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
    /// Triggers the interactor data fetchers methods. They are zipped from 1 batch.
    /// It means when all the requests completed the datas collected and needed publisher data filler methods called.
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
    /// Sets the poster paths for movies by converting the given movie list into banner content.
    /// If the movie list is valid and non-empty, it updates the last discovered movie ID with the first movie's ID and creates a list of `BannerContent` from the movie titles and backdrop image URLs.
    /// - Parameter movieList: An optional array of `Movie` objects containing information such as title, ID, and backdrop image URL. If the array is empty or nil, the method will return without making changes.
    final func setMoviesPosterPaths(with movieList: [Movie]?)  {
        guard let movieList,
              !movieList.isEmpty,
              let firstID = movieList.first?.id else { return }
        setLastDiscoveredMovieID(with: firstID)
        banners = movieList.compactMap { movie in
            return BannerContentModel(
                title: movie.title,
                imageURL: movie.bannerImageURL,
                movieID: movie.id
            )
        }
    }
    
    /// Checks the saved movieID's existance. If it is not setted then sets the first discovered movies ID.
    final func setLastDiscoveredMovieID(with firstDiscoveredID: Int) {
        guard UserManager.shared.lastDiscoveredMovieID == nil else { return }
        SessionManager.shared.lastDiscoveredMovieID.send("\(firstDiscoveredID)")
    }
    
    /// Prepares the collection content by processing genres and people lists into `HomeContent` objects.
    /// The method assigns the genres to the instance property, converts the genres and people lists into content sections, and adds them to a temporary collection.
    /// This temporary collection is then assigned to the `content` property.
    /// - Parameters:
    ///   - genres: An optional array of `Genre` objects to be converted into a `HomeContent` section. If `nil`, no genre section will be added.
    ///   - peopleList: An optional array of `PeopleContent` objects to be converted into a `HomeContent` section. If `nil`, no people section will be added.
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
    
    /// Creates a `HomeContent` object representing a list of genres.
    ///
    /// This method processes an optional array of `Genre` objects, converting them into `HomeGenre` and `HomeItemType` objects for display in a home content section.
    /// If the array is empty or `nil`, the method returns `nil`.
    ///
    /// - Parameter movieGenres: An optional array of `Genre` objects to be converted. Each genre's `id` and `name` are used to create `HomeGenre` objects. If `movieGenres` is `nil`, an empty array is used.
    /// - Returns: An optional `HomeContent` object. If there are genres to display, it contains a section with a header title and a list of genre items. If there are no genres, the method returns `nil`.
    final func getGenreContent(with movieGenres: [Genre]?) -> HomeContent? {
        let homeTypeGenreList: [HomeGenre] = (movieGenres ?? []).compactMap { genre in
            return HomeGenre(id: genre.id, name: GenreType(rawValue: genre.name ?? ""))
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
    
    /// Creates a `HomeContent` object for displaying a predefined list of categories.
    ///
    /// This method constructs a `HomeContent` object that includes a section of categories, each represented as a `HomeItemType.category` item. The section is titled "Discover" and contains items for various movie categories.
    ///
    /// - Returns: A `HomeContent` object with a section that includes a header title and a list of predefined categories. The categories are: "Now Playing," "Top Rated," "Upcoming," and "Popular."
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
    
    /// Generates a `HomeContent` object for displaying a list of people.
    ///
    /// This method processes an optional array of `PeopleContent` objects, filtering and converting them into `HomeItemType` objects for display in a home content section.
    /// The filtering criteria include that the person's name must match their original name, and their ID must be within a predefined limit. Only valid people are included in the resulting content.
    ///
    /// - Parameter fetchedPeopleList: An optional array of `PeopleContent` objects to be processed. Each person is filtered based on name and ID criteria. If `fetchedPeopleList` is `nil`, an empty array is used.
    /// - Returns: An optional `HomeContent` object. If there are valid people to display, it contains a section with a header title and a list of person items. If there are no valid people, the method returns `nil`.
    final func getPersonContent(with fetchedPeopleList: [PeopleContent]?) -> HomeContent? {
        let filteredPeopleList = fetchedPeopleList?.filter({ people in
            people.name == people.originalName
            && (people.id ?? 0) <= Constants.Default.maxIDLimit
        })
        peopleList = filteredPeopleList
        let items: [HomeItemType] = filteredPeopleList?.compactMap { people in
            let personContent = PersonContentModel(
                artistName: people.name,
                profileImageURL: people.profileImageURL,
                knownedMoviePosters: people.knownFor?.compactMap { $0.backDropImageURL } ?? []
            )
            return HomeItemType.person(cellContent: personContent)
        } ?? []
        
        guard !items.isEmpty else { return nil }
        return HomeContent(
            sectionType: .celebrities(headerTitle: L10nHome.celebrities.localized()),
            items: items
        )
    }
}
