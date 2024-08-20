//
//  FavoritesRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 20.08.2024.
//

import Components
import UIKit

// MARK: - FavoritesRouter
final public class FavoritesRouter: BaseRouter {
    // MARK: - Privates
    private weak var viewController: FavoritesViewController?
    
    // MARK: - Module
    public override func getModule() -> UIViewController {
        let view = FavoritesViewController()
        let interactor = FavoritesInteractor()
        let router = self
        let presenter = FavoritesPresenter(
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
