//
//  AppRouter+Home.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import Foundation
import Utility
import Home

extension AppRouter {
    public func routeToHome() {
        let homeRouter = HomeRouter(navigationController)
        homeRouter.delegate = self
        let homeViewController = homeRouter.createModule()
        navigationController.setViewControllers([homeViewController], animated: false)
        window?.switchRootViewController(to: navigationController)
    }
}

