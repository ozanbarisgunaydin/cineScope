//
//  SearchPresenter.swift
//
//
//  Created by Ozan Barış Günaydın on 16.08.2024.
//

import AppManagers
import Combine
import Components
import Foundation

// MARK: - SearchPresenterProtocol
protocol SearchPresenterProtocol: BasePresenterProtocol {
    /// Components
    var view: SearchViewProtocol? { get set }
    var interactor: SearchInteractorProtocol { get set }
    /// Variables
    var contentPublisher: Published<[SearchContent]>.Publisher { get }
    /// Functions
    func fetchContent()
}

// MARK: - SearchPresenter
final class SearchPresenter: BasePresenter, SearchPresenterProtocol {
    // MARK: - Components
    weak var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol
    
    // MARK: - Published Variables
    @Published var content: [SearchContent] = []
    var contentPublisher: Published<[SearchContent]>.Publisher { $content }
    
    // MARK: - Privates
    private var searchType: SearchType
    
    // MARK: - Init
    init(
        view: SearchViewProtocol,
        interactor: SearchInteractorProtocol,
        router: BaseRouterProtocol,
        searchType: SearchType
    ) {
        self.view = view
        self.interactor = interactor
        self.searchType = searchType
        super.init(router: router)
    }
}

// MARK: - Publics
extension SearchPresenter {
    final func fetchContent() {
        switch searchType {
        case .company:
            fetchDisoveredMovies(with: searchType.parameter)
        default:
            break
        }
    }
}

// MARK: - Fetchers
private extension SearchPresenter {
    final func fetchDisoveredMovies(with parameters: [String: Any]) {
        isLoading.send(true)
        interactor.fetchDiscoveredMovies(with: parameters).sink(receiveCompletion: {[weak self] completion in
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
        },receiveValue: { [weak self] movies in
            guard let self else { return }
            fillContent(with: movies)
        })
        .store(in: &cancellables)
    }
}

// MARK: - Helpers
private extension SearchPresenter {
    final func fillContent(with movies: [Movie]?) {
        let items: [SearchItemType] = (movies ?? []).compactMap{ movie in
            let content = MovieListCellContent(
                id: movie.id,
                title: movie.title,
                posterURL: movie.posterImageURL,
                year: movie.releaseDate,
                vote: "\(movie.voteAverage ?? 0)"
            )
            return SearchItemType.movie(cellContent: content)
        }
        
        content = [
            SearchContent(
                sectionType: .movieList,
                items: items
            )
        ]
    }
}
