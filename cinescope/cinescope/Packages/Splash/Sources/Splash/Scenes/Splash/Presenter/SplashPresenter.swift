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
    /// Components
    var view: SplashViewProtocol? { get set }
    var interactor: SplashInteractorProtocol { get set }
    /// Functions
    func routeToTabBar()
}

// MARK: - SplashPresenter
final class SplashPresenter: BasePresenter, SplashPresenterProtocol {
    // MARK: - Components
    weak var view: SplashViewProtocol?
    var interactor: SplashInteractorProtocol
    
    // MARK: - Init
    init(
        view: SplashViewProtocol,
        interactor: SplashInteractorProtocol,
        router: BaseRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        super.init(router: router)
    }
    
    func routeToTabBar() {
        router?.navigate(.tabBar)
    }
}
