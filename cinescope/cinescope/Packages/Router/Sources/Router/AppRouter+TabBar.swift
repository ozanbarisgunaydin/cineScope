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
        let tabBarRouter = TabBarRouter(
            delegate: self,
            navigationController
        )
        let tabBarController = tabBarRouter.getModule()
        navigationController.setViewControllers([tabBarController], animated: false)
        window?.switchRootViewController(to: navigationController)
    }
}
