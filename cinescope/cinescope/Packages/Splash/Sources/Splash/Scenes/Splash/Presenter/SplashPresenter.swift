//
//  SplashPresenter.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import Foundation

protocol SplashPresenterProtocol: AnyObject {
    func viewDidAppear()
    func routeToHome()
}

final class SplashPresenter: SplashPresenterProtocol {
    unowned var view: SplashViewControllerProtocol?
    let router: SplashRouterProtocol?
    let interactor: SplashInteractorProtocol?
    
    init(
        view: SplashViewControllerProtocol,
        router: SplashRouterProtocol?,
        interactor: SplashInteractorProtocol
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidAppear() {

    }
    
    func routeToHome() {
        router?.routeToHome()
    }
}


extension SplashPresenter: SplashInteractorOutputProtocol {
    
    func internetConnection(status: Bool) {
        if status {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.routeToHome()
            }
        } else {
            
        }
    }
}

