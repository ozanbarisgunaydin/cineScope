//
//  SearchTabRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import Components
import UIKit

// MARK: - SearchTabRouter
final public class SearchTabRouter: BaseRouter {
    // MARK: - Privates
    private weak var viewController: SearchTabViewController?
    
    // MARK: - Module
    public override func getModule() -> UIViewController {
        let view = SearchTabViewController()
        let interactor = SearchTabInteractor()
        let router = self
        let presenter = SearchTabPresenter(
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
