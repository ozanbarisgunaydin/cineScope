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
    var keywordNotifier: PassthroughSubject<Void, Never> { get }
    /// Functions
    func fetchContent()
    func routeToSearch(with keyword: String)
    func getKeywordsCount() -> Int?
    func getKeyword(for index: Int) -> String?
    func routeToSearch(on index: Int)
}

// MARK: - SearchPresenter
final class SearchTabPresenter: BasePresenter, SearchTabPresenterProtocol {
    // MARK: - Components
    weak var view: SearchTabViewProtocol?
    var interactor: SearchTabInteractorProtocol
    
    // MARK: - Private Variables
    private var keywords: [String]?
    
    // MARK: - PublishedVariables
    var keywordNotifier = PassthroughSubject<Void, Never>()
    
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
    final func fetchContent() {
        fetchKeywords()
    }
    
    final func routeToSearch(with keyword: String) {
        router?.navigate(.search(type: .query(text: keyword)))
    }
    
    final func getKeywordsCount() -> Int? {
        return keywords?.count
    }
    
    final func getKeyword(for index: Int) -> String? {
        return keywords?[safe: index]
    }
    
    final func routeToSearch(on index: Int) {
        guard let keyword = getKeyword(for: index) else { return }
        routeToSearch(with: keyword)
    }
}

// MARK: - Helpers
private extension SearchTabPresenter {
    final func fetchKeywords() {
        isLoading.send(true)
        interactor.fetchKeywords().sink(receiveCompletion: {[weak self] completion in
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
        },receiveValue: { [weak self] keywords in
            guard let self else { return }
            self.keywords = keywords
            keywordNotifier.send()
        })
        .store(in: &cancellables)
    }
}
