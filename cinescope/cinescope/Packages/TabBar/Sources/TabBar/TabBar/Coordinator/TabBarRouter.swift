//
//  TabBarRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 18.12.2023.
//

import AppResources
import Components
import Favorites
import Home
import Search
import UIKit
import Utility

// MARK: - TabBarRouter
public final class TabBarRouter: BaseRouter {
    // MARK: - Privates
    private weak var tabBarController: TabBarViewController?
    
    // MARK: - Constants
    private let tabItemInset = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
    private let middleTabtemInset = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
    private let selectedTintColor = UIColor.white
    private let unselectedTintColor = UIColor.lightGray
    
    // MARK: - Publics
    public let homeRouter: HomeRouter
    public let searchRouter: SearchTabRouter
    public let favoritesRouter: FavoritesRouter

    public var routers: [BaseRouter] {
        return [
            homeRouter,
            searchRouter,
            favoritesRouter
        ]
    }

    public var currentRouter: BaseRouter {
        let index = Constants.TabBarIndex(rawValue: tabBarController?.selectedIndex ?? 0) ?? .home
        switch index {
        case .home: return homeRouter
        case .search: return searchRouter
        case .favorites: return favoritesRouter
        }
    }

    // MARK: - Init
    public init(
        delegate: BaseRouterProtocol,
        _ navigationController: UINavigationController
    ) {
        /// Home
        let homeNC = BaseNavigationController()
        homeNC.tabBarItem = UITabBarItem(
            title: TabBarLocalizableKey.home.localized(),
            image: .homeTabUnselected,
            selectedImage: .homeTabSelected
        )
        homeNC.tabBarItem.imageInsets = tabItemInset
        homeRouter = HomeRouter(delegate: delegate, homeNC)
        homeNC.tabBarItem.tag = Constants.TabBarIndex.home.rawValue

        /// Search
        let searchNC = BaseNavigationController()
        searchNC.tabBarItem = UITabBarItem(
            title: TabBarLocalizableKey.search.localized(),
            image: .searchTabUnselected,
            selectedImage: .searchTabSelected
        )
        searchNC.tabBarItem.imageInsets = middleTabtemInset

        searchRouter = SearchTabRouter(delegate: delegate, searchNC)
        searchNC.tabBarItem.tag = Constants.TabBarIndex.search.rawValue

        /// Favorites
        let favoritesNC = BaseNavigationController()
        favoritesNC.tabBarItem = UITabBarItem(
            title: TabBarLocalizableKey.favorites.localized(),
            image: .favoritesTabUnselected,
            selectedImage: .favoritesTabSelected
        )
        favoritesNC.tabBarItem.imageInsets = tabItemInset
        favoritesRouter = FavoritesRouter(delegate: delegate, favoritesNC)
        favoritesNC.tabBarItem.tag = Constants.TabBarIndex.favorites.rawValue
        
        super.init(delegate: delegate, navigationController)
    }

    // MARK: - Module
    public override func getModule() -> UITabBarController {
        let controller = TabBarViewController(router: self)
        var viewControllers: [UIViewController] = []
        routers.forEach { viewController in
            viewControllers.append(viewController.getModule())
        }
        controller.viewControllers = viewControllers
        tabBarController = controller

        return controller
    }

    // MARK: - Public
    final public func selectTab(at index: Int) {
        tabBarController?.selectedIndex = index
    }
}
