//
//  FavoritesPresenter.swift
//
//
//  Created by Ozan Barış Günaydın on 20.08.2024.
//

import AppManagers
import AppResources
import Combine
import Components
import Foundation

// MARK: - FavoritesPresenterProtocol
protocol FavoritesPresenterProtocol: BasePresenterProtocol {
    /// Components
    var view: FavoritesViewProtocol? { get set }
    var interactor: FavoritesInteractorProtocol { get set }
    /// Variables
    var contentPublisher: Published<[FavoritesContent]>.Publisher { get }
    /// Functions
    func fetchContent()
    func routeToDetail(for index: Int)
    func removeFromFavorites(on index: Int)
}

// MARK: - FavoritesPresenter
final class FavoritesPresenter: BasePresenter, FavoritesPresenterProtocol {
    // MARK: - Components
    weak var view: FavoritesViewProtocol?
    var interactor: FavoritesInteractorProtocol
    
    // MARK: - Published Variables
    @Published var content: [FavoritesContent] = []
    var contentPublisher: Published<[FavoritesContent]>.Publisher { $content }
    
    // MARK: - Private Variables
    private var movieIDList: [Int] = []
    
    // MARK: - Init
    init(
        view: FavoritesViewProtocol,
        interactor: FavoritesInteractorProtocol,
        router: BaseRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        super.init(router: router)
    }
}

// MARK: - Publics
extension FavoritesPresenter {
    final func fetchContent() {
        observeFavorites()
    }
    
    final func routeToDetail(for index: Int) {
        guard let movieID = movieIDList[safe: index] else { return }
        
        router?.navigate(.detail(id: movieID))
    }
    
    final func removeFromFavorites(on index: Int) {
        guard let movieCellContent = content.first?.items[safe: index],
              case let .movie(value) = movieCellContent else { return }
        SessionManager.shared.removeFromFavorites(value)
    }
}

// MARK: - Helpers
private extension FavoritesPresenter {
    final func observeFavorites() {
        SessionManager.shared.favorites
            .sink { _ in } receiveValue: { [weak self] favoriteMovies in
                guard let self else { return }
                movieIDList = favoriteMovies.compactMap({$0.id})
                prepareFavoritesContent(with: favoriteMovies)
            }
            .store(in: &cancellables)
    }
    
    final func prepareFavoritesContent(with favoriteMovies: [FavoriteCellContent]) {
        let items = favoriteMovies.map { cellContent in
            return FavoritesItemType.movie(cellContent: cellContent)
        }
        content = [FavoritesContent(sectionType: .movieList, items: items)]
    }
}
