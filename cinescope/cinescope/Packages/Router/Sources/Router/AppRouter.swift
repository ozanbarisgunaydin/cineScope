//
//  AppRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import Components
import Detail
import Splash
import Home
import TabBar
import UIKit

typealias Routes = SplashRouterProtocol
& HomeRouterProtocol
& TabBarRouterProtocol
& DetailRouterProtocol

public final class AppRouter: BaseRouter, Routes {
    // MARK: - App
    weak var window: UIWindow?
    
    // MARK: - Init
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

// MARK: - HomeRouterProtocol
public extension AppRouter {
    func navigate(_ route: HomeRoutes) {
        switch route {
        case .listScreen:
            print("⭕️ \(#function) list screen routing")
        case .detail(let id):
            routeToDetail(with: id)
        }
    }
    
    func navigate(_ route: SplashRoutes) {
        switch route {
        case .tabBar:
            routeToTabBar()
        }
    }
    
    func navigate(_ route: DetailRoutes) {
        /* no - op*/
    }
}
