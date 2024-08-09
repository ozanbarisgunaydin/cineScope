//
//  AppRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import Components
import Splash
import UIKit

typealias Routes = SplashRouterProtocol

public final class AppRouter: BaseRouter, Routes {
    weak var window: UIWindow?
    
    required public init(
        _ navigationController: UINavigationController = BaseNavigationController(),
        window: inout UIWindow?
    ) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        self.window = window
        super.init(navigationController)
    }
    
    public func start() {
        routeToSplash()
    }
}
