//
//  HomeRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import Components
import UIKit

// MARK: - HomeRouter
final public class HomeRouter: BaseRouter {
    // MARK: - Privates
    private weak var viewController: HomeViewController?

    // MARK: - Module    
    public override func getModule() -> UIViewController {
        let view = HomeViewController()
        let interactor = HomeInteractor()
        let router = self
        let presenter = HomePresenter(
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
