//
//  AppDelegate+Init.swift
//  oleycom
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Foundation
import UIKit
import Core
import Logger
import IQKeyboardManagerSwift
import Kingfisher
import AppResources
import DeepLink

extension AppDelegate {
    func commonInit(
        _ application: UIApplication
    ) {
        BaseURLChanger.shared.initialize()

        initializeLogSystem()
        initializeImageCache()
        initializeKeyboardManager()
        initializeFirebase()
        initializeAppResources()
        initializeDeepLinkManager()
    }
}

fileprivate extension AppDelegate {
    func initializeLogSystem() {
        #if DEBUG
        Logger.configure(logLevel: .debug)
        #else
        Logger.configure(logLevel: .none)
        #endif
        log("\(Bundle.main.applicationName) - v\(Bundle.main.appShortVersion) Build:\(Bundle.main.appVersion)")
    }

    func initializeFirebase() {
        FirebaseConfigurator.start()
    }

    func initializeKeyboardManager() {
        let keyboardManager = IQKeyboardManager.shared
        keyboardManager.keyboardDistanceFromTextField = 20.0
        keyboardManager.enableAutoToolbar = false
        keyboardManager.resignOnTouchOutside = true
        keyboardManager.enable = true
    }

    func initializeImageCache() {
        let cache = ImageCache.default
        cache.memoryStorage.config.expiration = .seconds(600)
        cache.diskStorage.config.expiration = .days(3)
        cache.cleanExpiredMemoryCache()
        cache.cleanExpiredDiskCache()
    }

    func initializeAppResources() {
        let resources = AppResources.shared
        let config = BaseURLChanger.shared.config
        guard
            let baseURL = config?.environment(for: .baseURL, environmentType: .prod)?.value
        else { fatalError("baseURL can not be nil") }
        resources.baseURL = baseURL
        guard
            let cdnURL = config?.environment(for: .cdnURL, environmentType: .prod)?.value
        else { fatalError("cdnURL can not be nil") }
        resources.cdnURL = cdnURL
    }

    func initializeDeepLinkManager() {
        DeepLinkManager.shared.configure(
            delegate: self,
            routes: DeeplinkConstants.deeplinkPrefixes
        )
    }
}
