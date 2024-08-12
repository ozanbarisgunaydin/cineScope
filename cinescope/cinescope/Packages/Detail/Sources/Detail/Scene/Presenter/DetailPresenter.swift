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
    var router: DetailRouterProtocol { get set }
    /// Variables
    
    /// Functions
}

// MARK: - DetailPresenter
final class DetailPresenter: DetailPresenterProtocol {
    // MARK: - Base Variables
    public var isLoading = PassthroughSubject<Bool, Error>()
    public var alert = PassthroughSubject<AlertContent?, Error>()
    public var cancellables: [AnyCancellable] = []
    
    // MARK: - Components
    weak var view: DetailViewProtocol?
    var interactor: DetailInteractorProtocol
    var router: DetailRouterProtocol
    
    // MARK: - Published Variables
    
    // MARK: - Init
    init(
        view: DetailViewProtocol,
        interactor: DetailInteractorProtocol,
        router: DetailRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - Publics
extension DetailPresenter {
}

// MARK: - Helpers
private extension DetailPresenter {
}
