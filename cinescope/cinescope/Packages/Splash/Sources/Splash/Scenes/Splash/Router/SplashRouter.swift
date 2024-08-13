//
//  SplashRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import Components
import UIKit

// MARK: - SplashRouter
final public class SplashRouter: BaseRouter {
    // MARK: - Privates
    private weak var viewController: SplashViewController?
    
    // MARK: - Module
    public override func getModule() -> UIViewController {
        let view = SplashViewController()
        let interactor = SplashInteractor()
        let router = self
        let presenter = SplashPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        router.viewController = view
        
        navigationController.setViewControllers([view], animated: false)
        
        return navigationController
    }
}
