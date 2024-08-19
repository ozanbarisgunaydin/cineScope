//
//  SearchTabPresenter.swift
//
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import Combine
import Components
import Foundation
import Utility

// MARK: - SearchTabPresenterProtocol
protocol SearchTabPresenterProtocol: BasePresenterProtocol {
    /// Components
    var view: SearchTabViewProtocol? { get set }
    var interactor: SearchTabInteractorProtocol { get set }
    /// Variables
    
    /// Functions
    func routeToSearch(with keyword: String)
}

// MARK: - SearchPresenter
final class SearchTabPresenter: BasePresenter, SearchTabPresenterProtocol {
    // MARK: - Components
    weak var view: SearchTabViewProtocol?
    var interactor: SearchTabInteractorProtocol
    
    // MARK: - Published Variables
    
    // MARK: - Public Variables
    
    // MARK: - Init
    init(
        view: SearchTabViewProtocol,
        interactor: SearchTabInteractorProtocol,
        router: BaseRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        super.init(router: router)
    }
}

// MARK: - Publics
extension SearchTabPresenter {
    final func routeToSearch(with keyword: String) {
        router?.navigate(.search(type: .query(text: keyword)))
    }
}
