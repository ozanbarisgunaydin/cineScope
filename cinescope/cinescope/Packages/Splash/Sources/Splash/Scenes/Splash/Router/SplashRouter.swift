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
    func routeToTabBar()
}

// MARK: - SplashRoutes
public enum SplashRoutes {
    case tabBar
}

// MARK: - SplashRouter
final public class SplashRouter: BaseRouter {
    // MARK: - Publics
    public weak var delegate: SplashRouterProtocol?
    
    weak var viewController: SplashViewController?
    
    public override func createModule() -> BaseViewController {
        let view = SplashViewController()
        let interactor = SplashInteractor()
        let router = self
        let presenter = SplashPresenter(view: view, router: delegate, interactor: interactor)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}
