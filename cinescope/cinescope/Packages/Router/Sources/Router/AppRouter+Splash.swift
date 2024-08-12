//
//  AppRouter+Splash.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import Foundation
import Utility
import Splash

extension AppRouter {
    public func routeToSplash() {
        let splashRouter = SplashRouter(navigationController)
        splashRouter.delegate = self
        let splashModule = splashRouter.createModule()
        window?.switchRootViewController(to: splashModule)
    }
}
