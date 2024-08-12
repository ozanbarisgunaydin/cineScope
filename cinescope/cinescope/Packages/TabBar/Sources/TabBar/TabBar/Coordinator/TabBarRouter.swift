//
//  TabBarRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 18.12.2023.
//

import UIKit
import Utility
import Components
import AppResources
import Home

// MARK: - RoutingProtocols
public typealias TabBarRoutes = HomeRouterProtocol
public protocol TabBarRouterProtocol: TabBarRoutes {}

// MARK: - TabBarRouter
public final class TabBarRouter {
    // MARK: - Privates
    private weak var tabBarController: TabBarViewController?
    private var navigationController: UINavigationController
    
    // MARK: - Constants
    private let tabItemInset = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
    private let middleTabtemInset = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
    private let selectedTintColor = UIColor.white
    private let unselectedTintColor = UIColor.lightGray
    
    // MARK: - Publics
    public weak var delegate: TabBarRouterProtocol? {
        didSet {
            homeRouter.delegate = delegate
            searchRouter.delegate = delegate
            favoritesRouter.delegate = delegate
        }
    }

    public let homeRouter: HomeRouter
    public let searchRouter: HomeRouter
    public let favoritesRouter: HomeRouter

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
    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        /// Home
        let homeNC = BaseNavigationController()
        homeNC.tabBarItem = UITabBarItem(
            title: TabBarLocalizableKey.home.localized(),
            image: .homeTabUnselected,
            selectedImage: .homeTabSelected
        )
        homeNC.tabBarItem.imageInsets = tabItemInset
        homeRouter = HomeRouter(homeNC)
        homeNC.tabBarItem.tag = Constants.TabBarIndex.home.rawValue

        /// Search
        let searchNC = BaseNavigationController()
        searchNC.tabBarItem = UITabBarItem(
            title: TabBarLocalizableKey.search.localized(),
            image: .searchTabUnselected,
            selectedImage: .searchTabSelected
        )
        searchNC.tabBarItem.imageInsets = middleTabtemInset

        searchRouter = HomeRouter(searchNC)
        searchNC.tabBarItem.tag = Constants.TabBarIndex.search.rawValue

        /// Favorites
        let favoritesNC = BaseNavigationController()
        favoritesNC.tabBarItem = UITabBarItem(
            title: TabBarLocalizableKey.favorites.localized(),
            image: .favoritesTabUnselected,
            selectedImage: .favoritesTabSelected
        )
        favoritesNC.tabBarItem.imageInsets = tabItemInset
        favoritesRouter = HomeRouter(favoritesNC)
        favoritesNC.tabBarItem.tag = Constants.TabBarIndex.favorites.rawValue
    }

    // MARK: - Module
    public func createModule() -> UITabBarController {
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
