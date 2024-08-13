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

// MARK: - DetailPresenterProtocol
protocol DetailPresenterProtocol: BasePresenterProtocol {
    /// Components
    var view: DetailViewProtocol? { get set }
    var interactor: DetailInteractorProtocol { get set }
    /// Variables
    var headerPublisher: Published<MovieHeaderContent?>.Publisher { get }
    /// Functions
    func fetchContent()
}

// MARK: - DetailPresenter
final class DetailPresenter: BasePresenter, DetailPresenterProtocol {
    // MARK: - Components
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorProtocol

    // MARK: - Published Variables
    @Published var headerContent: MovieHeaderContent?
    var headerPublisher: Published<MovieHeaderContent?>.Publisher { $headerContent }
    
    // MARK: - Privates
    private var movieID: Int
    
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
        fetchMovieDetail()
    }
}

// MARK: - Helpers
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
            setHeaderContent(with: movie)
        })
        .store(in: &cancellables)
    }
    
    final func setHeaderContent(with movie: Movie) {
        headerContent = MovieHeaderContent(
            title: movie.title,
            originalTitle: movie.originalTitle,
            posterImageURL: movie.posterImageURL,
            releaseDate: movie.releaseDate?.convertDateFormat(),
            budget: movie.budget?.toAbbreviatedDollarCurrency(),
            revenue: movie.revenue?.toAbbreviatedDollarCurrency(),
            vote: VoteContent(
                average: String(movie.voteAverage ?? 0.0),
                count: String(movie.voteCount ?? 0)
            )
        )
    }
}
