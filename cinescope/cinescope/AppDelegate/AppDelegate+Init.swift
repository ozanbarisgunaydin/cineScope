//
//  AppDelegate+Init.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Atlantis
import Foundation
import UIKit
import IQKeyboardManagerSwift
import Kingfisher
import AppResources

extension AppDelegate {
    func commonInit(
        _ application: UIApplication
    ) {
        Atlantis.start()
        initializeImageCache()
        initializeKeyboardManager()
    }
}

fileprivate extension AppDelegate {
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
}
