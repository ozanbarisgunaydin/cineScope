//
//  AppRouter+TabBar.swift
//
//
//  Created by Ozan Barış Günaydın on 12.08.2024.
//

import Components
import TabBar

extension AppRouter {
    public func routeToTabBar() {
        let tabBarRouter = TabBarRouter(navigationController)
        tabBarRouter.delegate = self
        let tabBarViewController = tabBarRouter.createModule()
        navigationController.setViewControllers([tabBarViewController], animated: false)
        window?.switchRootViewController(to: navigationController)
    }
}
