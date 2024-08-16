//
//  SearchRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 16.08.2024.
//

import Components
import UIKit

// MARK: - SearchRouter
final public class SearchRouter: BaseRouter {
    // MARK: - Privates
    private weak var viewController: SearchViewController?
    private var searchType: SearchType
    
    // MARK: - Init
    public init(
        delegate: BaseRouterProtocol?,
        searchType: SearchType,
        _ navigationController: UINavigationController
    ) {
        self.searchType = searchType
        super.init(delegate: delegate, navigationController)
    }
    
    // MARK: - Module
    public override func createModule() {
        let view = SearchViewController()
        let interactor = SearchInteractor()
        let router = self
        let presenter = SearchPresenter(
            view: view,
            interactor: interactor,
            router: router,
            searchType: searchType
        )
        
        view.presenter = presenter
        router.viewController = view
        
        view.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(view, animated: true)
    }
}
