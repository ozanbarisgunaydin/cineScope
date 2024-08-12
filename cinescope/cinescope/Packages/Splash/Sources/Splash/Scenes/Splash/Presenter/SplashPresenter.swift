//
//  SplashPresenter.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import Combine
import Components
import Foundation

// MARK: - SplashPresenterProtocol
protocol SplashPresenterProtocol: BasePresenterProtocol {
    /// Functions
    func routeToTabBar()
}

// MARK: - SplashPresenter
final class SplashPresenter: SplashPresenterProtocol {
    // MARK: - Base Variables
    public var isLoading = PassthroughSubject<Bool, Error>()
    public var alert = PassthroughSubject<AlertContent?, Error>()
    public var cancellables: [AnyCancellable] = []
    
    // MARK: - Components
    weak var view: SplashViewProtocol?
    var interactor: SplashInteractorProtocol
    var router: SplashRouterProtocol
    
    // MARK: - Init
    init(
        view: SplashViewProtocol,
        interactor: SplashInteractorProtocol,
        router: SplashRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func routeToTabBar() {
        router.navigate(.tabBar)
    }
}
