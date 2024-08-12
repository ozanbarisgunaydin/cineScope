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
    // MARK: - Publics
    public weak var delegate: SplashRouterProtocol?
    
    // MARK: - Privates
    private weak var viewController: SplashViewController?
    
    // MARK: - Init
    public init(
        delegate: SplashRouterProtocol?,
        _ navigationController: UINavigationController
    ) {
        self.delegate = delegate
        super.init(navigationController)
    }
    
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
        
        return view
    }
}

// MARK: - Navigates
extension SplashRouter: SplashRouterProtocol {
    public func navigate(_ route: SplashRoutes) {
        delegate?.navigate(route)
    }
}
