//
//  AppDelegate.swift
//  cinescope
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import Router
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var appRouter = AppRouter(window: &window)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        commonInit(application)
        appRouter.start()
        
        return true
    }
}

