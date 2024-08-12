//
//  File.swift
//  
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import Components
import UIKit

// MARK: - HomeRouterProtocol
public protocol HomeRouterProtocol: AnyObject {
    func navigate(_ route: HomeRoutes)
}

// MARK: - HomeRoutes
public enum HomeRoutes {
    case listScreen
    case detail(id: Int)
}

// MARK: - HomeRouter
final public class HomeRouter: BaseRouter {
    // MARK: - Publics
    public weak var delegate: HomeRouterProtocol?
    
    // MARK: - Privates
    private weak var viewController: HomeViewController?
    
    // MARK: - Init
    public init(
        delegate: HomeRouterProtocol? = nil,
        _ navigationController: UINavigationController
    ) {
        self.delegate = delegate
        super.init(navigationController)
    }

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

// MARK: - Navigates
extension HomeRouter: HomeRouterProtocol {
    public func navigate(_ route: HomeRoutes) {
        delegate?.navigate(route)
    }
}
