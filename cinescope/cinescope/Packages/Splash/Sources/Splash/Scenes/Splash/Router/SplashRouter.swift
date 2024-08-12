//
//  SplashRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import Components
import UIKit

// MARK: - SplashRouterProtocol
public protocol SplashRouterProtocol: AnyObject {
    func navigate(_ route: SplashRoutes)
}

// MARK: - SplashRoutes
public enum SplashRoutes {
    case tabBar
}

// MARK: - SplashRouter
final public class SplashRouter: BaseRouter {
    // MARK: - Variables
    weak var viewController: SplashViewController?
    public weak var delegate: SplashRouterProtocol?
    
    // MARK: - Module
    public override func createModule() -> UIViewController {
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

// MARK: - Navigates
extension SplashRouter: SplashRouterProtocol {
    public func navigate(_ route: SplashRoutes) {
        delegate?.navigate(route)
    }
}
