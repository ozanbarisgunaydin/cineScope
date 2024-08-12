//
//  DetailRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import Components
import UIKit

// MARK: - DetailRouterProtocol
public protocol DetailRouterProtocol: AnyObject {
    func navigate(_ route: DetailRoutes)
}

// MARK: - DetailRoutes
public enum DetailRoutes {
    /* no - op */
}

// MARK: - DetailRouter
final public class DetailRouter: BaseRouter {
    // MARK: - Publics
    public weak var delegate: DetailRouterProtocol?
    
    // MARK: - Privates
    private weak var viewController: DetailViewController?
    private var movieID: Int
    
    // MARK: - Init
    public init(
        delegate: DetailRouterProtocol?,
        movieID: Int,
        _ navigationController: UINavigationController
    ) {
        self.delegate = delegate
        self.movieID = movieID
        super.init(navigationController)
    }
    
    // MARK: - Module
    public override func createModule() {
        let view = DetailViewController()
        let interactor = DetailInteractor()
        let router = self
        let presenter = DetailPresenter(
            view: view,
            interactor: interactor,
            router: router
        )
        
        view.presenter = presenter
        router.viewController = view
        
        view.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(view, animated: true)
    }
}

// MARK: - Navigates
extension DetailRouter: DetailRouterProtocol {
    public func navigate(_ route: DetailRoutes) { }
}

