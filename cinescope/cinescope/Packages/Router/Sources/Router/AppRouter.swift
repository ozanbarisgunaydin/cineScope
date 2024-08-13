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

public final class AppRouter: BaseRouter {
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
    
    // MARK: - Start
    public func start() {
        routeToSplash()
    }
    
    // MARK: - Route
    public override func navigate(_ route: AppRoutes) {
        switch route {
        case .tabBar:
            routeToTabBar()
        case .listScreen:
            print("⭕️ \(#function) list screen routing")
        case .detail(let id):
            routeToDetail(with: id)
        }
    }
}
