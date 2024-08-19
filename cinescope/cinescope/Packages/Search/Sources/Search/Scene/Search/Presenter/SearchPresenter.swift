//
//  SearchPresenter.swift
//
//
//  Created by Ozan Barış Günaydın on 16.08.2024.
//

import AppManagers
import AppResources
import Combine
import Components
import Foundation
import Network
import Utility

// MARK: - SearchPresenterProtocol
protocol SearchPresenterProtocol: BasePresenterProtocol {
    /// Components
    var view: SearchViewProtocol? { get set }
    var interactor: SearchInteractorProtocol { get set }
    /// Variables
    var contentPublisher: Published<[SearchContent]>.Publisher { get }
    var contentTitle: String? { get }
    var lastIndex: Int { get }
    /// Functions
    func fetchContent()
    func routeToDetail(for index: Int)
}

// MARK: - SearchPresenter
final class SearchPresenter: BasePresenter, SearchPresenterProtocol {
    // MARK: - Components
    weak var view: SearchViewProtocol?
    var interactor: SearchInteractorProtocol
    
    // MARK: - Published Variables
    @Published var content: [SearchContent] = []
    var contentPublisher: Published<[SearchContent]>.Publisher { $content }
    
    // MARK: - Public Variables
    var contentTitle: String? {
        switch searchType {
        case .query(text: let text):
            return text
        case let .company(content),
             let .genres(content),
             let  .people(content):
            return content.title ?? ""
            
        case .nowPlaying:
            return L10nCategory.nowPlaying.localized()
            
        case .popular:
            return L10nCategory.popular.localized()
            
        case .topRated:
            return L10nCategory.topRated.localized()
            
        case .upComing:
            return L10nCategory.upComing.localized()
        }
    }
    var lastIndex: Int {
        return (content.first?.items.count ?? 1) - 1
    }
    
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
        guard interactor.canFetchMore else { return }
        switch searchType {
        case .nowPlaying:
            fetchCategoryMovies(publisher: interactor.fetchNowPlayingMovies())

        case .popular:
            fetchCategoryMovies(publisher: interactor.fetchPopularMovies())
            
        case .topRated:
            fetchCategoryMovies(publisher: interactor.fetchTopRatedMovies())
            
        case .upComing:
            fetchCategoryMovies(publisher: interactor.fetchUpComingMovies())

        default:
            fetchDisoveredMovies(with: searchType.parameter)
        }
    }
    
    final func routeToDetail(for index: Int) {
        guard let movie = content.first?.items[safe: index],
              case let .movie(cellContent) = movie,
              let movieID = cellContent.id else { return }
        
        router?.navigate(.detail(id: movieID))
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
    
    final func fetchCategoryMovies(publisher: AnyPublisher<[Movie]?, BaseError>) {
        isLoading.send(true)
        publisher.sink(receiveCompletion: {[weak self] completion in
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
        let items: [SearchItemType] = (movies ?? []).compactMap { movie in
            let content = MovieListCellContent(
                id: movie.id,
                title: movie.title,
                posterURL: movie.posterImageURL,
                year: movie.releaseDate?.yearComponent,
                vote: movie.voteAverage.roundedString
            )
            return SearchItemType.movie(cellContent: content)
        }
        
        if content.isEmpty || (content.first?.items ?? []).isEmpty {
            content = [
                SearchContent(
                    sectionType: .movieList,
                    items: items
                )
            ]
        } else {
            let updatedContent = content
            var existedItems = updatedContent.first?.items ?? []
            existedItems.append(contentsOf: items)
            updatedContent.first?.items = removeDuplicates(from: existedItems)
            content = updatedContent
        }
    }
    
    final func removeDuplicates(from items: [SearchItemType]) -> [SearchItemType] {
        var seenIDs = Set<Int>()
        var uniqueItems = [SearchItemType]()
        
        for item in items {
            if case let .movie(cellContent) = item {
                if let id = cellContent.id, !seenIDs.contains(id) {
                    seenIDs.insert(id)
                    uniqueItems.append(item)
                }
            }
        }
        
        return uniqueItems
    }

}
