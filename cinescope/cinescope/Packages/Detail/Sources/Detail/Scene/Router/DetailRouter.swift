//
//  DetailRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import Components
import UIKit

// MARK: - DetailRouter
final public class DetailRouter: BaseRouter {
    // MARK: - Privates
    private weak var viewController: DetailViewController?
    private var movieID: Int
    
    // MARK: - Init
    public init(
        delegate: BaseRouterProtocol?,
        movieID: Int,
        _ navigationController: UINavigationController
    ) {
        self.movieID = movieID
        super.init(delegate: delegate, navigationController)
    }
    
    // MARK: - Module
    public override func createModule() {
        let view = DetailViewController()
        let interactor = DetailInteractor()
        let router = self
        let presenter = DetailPresenter(
            view: view,
            interactor: interactor,
            router: router,
            movieID: movieID
        )
        
        view.presenter = presenter
        router.viewController = view
        
        view.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(view, animated: true)
    }
}
