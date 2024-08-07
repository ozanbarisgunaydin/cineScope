//
//  AppDelegate.swift
//  cinescope
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit
import Coordinator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var appCoordinator = AppCoordinator(window: &window)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        commonInit(application)
        appCoordinator.start()
        
        return true
    }
}

