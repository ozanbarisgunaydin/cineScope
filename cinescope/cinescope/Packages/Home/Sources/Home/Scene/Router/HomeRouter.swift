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
}

// MARK: - HomeRouter
final public class HomeRouter: BaseRouter {
    
    weak var viewController: HomeViewController?
    
    public override func createModule() -> BaseViewController {
        let view = HomeViewController()
        let interactor = HomeInteractor()
        let router = HomeRouter(navigationController)
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        router.viewController = view
        return view
    }
}

// MARK: - Navigates
extension HomeRouter: HomeRouterProtocol {
    public func navigate(_ route: HomeRoutes) { }
}
