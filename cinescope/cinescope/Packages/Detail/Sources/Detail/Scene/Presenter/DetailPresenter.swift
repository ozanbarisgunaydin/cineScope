//
//  DetailPresenter.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import AppManagers
import Combine
import Components
import Foundation
import Utility

// MARK: - DetailPresenterProtocol
protocol DetailPresenterProtocol: BasePresenterProtocol {
    /// Components
    var view: DetailViewProtocol? { get set }
    var interactor: DetailInteractorProtocol { get set }
    /// Variables
    var headerPublisher: Published<MovieHeaderContent?>.Publisher { get }
    var linksPublisher: Published<MovieLinksContent?>.Publisher { get }
    var overviewPublisher: Published<String?>.Publisher { get }
    var genresPublisher: Published<[Genre]?>.Publisher { get }
    var similarMoviesPublisher: Published<[SimilarMovieContent]?>.Publisher { get }
    var companiesPublisher: Published<[MovieCompanyContent]?>.Publisher { get }
    var isFavorie: Bool { get set }
    /// Functions
    func fetchContent()
    func routeToWeb(with url: String)
    func routeToGenre(with id: Int)
    func routeToMovieDetail(with id: Int)
    func routeToCompany(with id: Int)
}

// MARK: - DetailPresenter
final class DetailPresenter: BasePresenter, DetailPresenterProtocol {
    // MARK: - Components
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorProtocol

    // MARK: - Published Variables
    @Published var headerContent: MovieHeaderContent?
    var headerPublisher: Published<MovieHeaderContent?>.Publisher { $headerContent }
    @Published var linksContent: MovieLinksContent?
    var linksPublisher: Published<MovieLinksContent?>.Publisher { $linksContent }
    @Published var overviewContent: String?
    var overviewPublisher: Published<String?>.Publisher { $overviewContent }
    @Published var genresContent: [Genre]?
    var genresPublisher: Published<[Genre]?>.Publisher { $genresContent }
    @Published var similarMoviesContent: [SimilarMovieContent]?
    var similarMoviesPublisher: Published<[SimilarMovieContent]?>.Publisher { $similarMoviesContent }
    @Published var companiesContent: [MovieCompanyContent]?
    var companiesPublisher: Published<[MovieCompanyContent]?>.Publisher { $companiesContent }
    
    // MARK: - Public Variable
    var isFavorie: Bool {
        get {
            let favoriteIDList = UserManager.shared.favorites.compactMap { $0.id }
            return favoriteIDList.contains(movieID)
        }

        set {
            changeFavoriteStatus(to: newValue)
        }
    }
    
    // MARK: - Privates
    private var movieID: Int
    private var movie: Movie?
    
    // MARK: - Init
    init(
        view: DetailViewProtocol,
        interactor: DetailInteractorProtocol,
        router: BaseRouterProtocol,
        movieID: Int
    ) {
        self.view = view
        self.interactor = interactor
        self.movieID = movieID
        super.init(router: router)
    }
}

// MARK: - Publics
extension DetailPresenter {
    final func fetchContent() {
        SessionManager.shared.lastDiscoveredMovieID.send("\(movieID)")
        fetchMovieDetail()
        fetchSimilarMovies()
    }
    
    final func routeToWeb(with url: String) {
        router?.navigate(.safariController(url: url))
    }
    
    final func routeToGenre(with id: Int) {
        guard let genre = movie?.genres?.first(where: { $0.id == id }),
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
    
    final func routeToMovieDetail(with id: Int) {
        router?.navigate(.detail(id: id))
    }
    
    final func routeToCompany(with id: Int) {
        guard let company = movie?.productionCompanies?.first(where: { $0.id == id }) else { return }
        let searchContent = NonQuerySearh(
            id: "\(company.id ?? 0)",
            title: company.name
        )
        router?.navigate(.search(type: .company(content: searchContent)))
    }
}

// MARK: - Fetchers
private extension DetailPresenter {
    final func fetchMovieDetail() {
        isLoading.send(true)
        interactor.fetchMovieDetail(with: movieID).sink(receiveCompletion: {[weak self] completion in
            guard let self else { return }
            switch completion {
            case .finished:
                isLoading.send(false)
            case .failure(let error):
                showServiceFailure(
                    errorMessage: error.friendlyMessage,
                    shouldGoBackOnDismiss: true
                )
            }
        },receiveValue: { [weak self] movie in
            guard let self else { return }
            self.movie = movie
            setHeaderContent()
            setLinksContent()
            overviewContent = movie.overview
            genresContent = movie.genres
            setCompaniesContent()
        })
        .store(in: &cancellables)
    }
    
    final func fetchSimilarMovies() {
        isLoading.send(true)
        interactor.fetchSimilarMovies(with: movieID).sink(receiveCompletion: {[weak self] completion in
            guard let self else { return }
            switch completion {
            case .finished:
                isLoading.send(false)
            case .failure(let error):
                showServiceFailure(
                    errorMessage: error.friendlyMessage,
                    shouldGoBackOnDismiss: true
                )
            }
        },receiveValue: { [weak self] similarMovies in
            guard let self else { return }
            setSimilarMoviesContent(with: similarMovies)
        })
        .store(in: &cancellables)
    }
}

// MARK: - Helpers
private extension DetailPresenter {
    final func setHeaderContent() {
        headerContent = MovieHeaderContent(
            title: movie?.title,
            originalTitle: movie?.originalTitle,
            posterImageURL: movie?.largePosterImageURL,
            releaseDate: movie?.releaseDate?.convertDateFormat(),
            budget: movie?.budget?.toAbbreviatedDollarCurrency(),
            revenue: movie?.revenue?.toAbbreviatedDollarCurrency(),
            vote: VoteContent(
                average: movie?.voteAverage.roundedStringWithSlashTen,
                count: String(movie?.voteCount ?? 0)
            )
        )
    }
    
    final func setLinksContent() {
        linksContent = MovieLinksContent(
            backgroundImageURL: movie?.backDropImageURL,
            imdbURL: movie?.imdbID.imdbURL,
            homePageURL: movie?.homepage
        )
    }
    
    final func setSimilarMoviesContent(with fetchedMovies: [Movie]?) {
        similarMoviesContent = fetchedMovies?.compactMap { movie in
            return SimilarMovieContent(
                imageURL: movie.posterImageURL,
                name: movie.title,
                id: movie.id
            )
        }
    }
    
    final func setCompaniesContent() {
        companiesContent = movie?.productionCompanies?.compactMap { company in
            return MovieCompanyContent(
                imageURL: company.logoImageURL,
                name: company.name,
                id: company.id
            )
        }
    }
    
    final func getFavoriteContent() -> FavoriteCellContent {
        return FavoriteCellContent(
            backdropImageURL: movie?.backDropImageURL,
            title: movie?.title,
            date: movie?.releaseDate?.yearComponent,
            vote: movie?.voteAverage.roundedStringWithSlashTen,
            id: movieID
        )
    }
    
    final func changeFavoriteStatus(to favoriteStatus: Bool) {
        let favoriteContent = getFavoriteContent()
        if favoriteStatus {
            SessionManager.shared.addToFavorites(favoriteContent)
        } else {
            SessionManager.shared.removeFromFavorites(favoriteContent)
        }
    }
}
