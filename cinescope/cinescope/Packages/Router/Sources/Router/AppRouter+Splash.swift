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
        let splashRouter = SplashRouter(delegate: self, navigationController)
        let splashModule = splashRouter.getModule()
        window?.switchRootViewController(to: splashModule)
    }
}
