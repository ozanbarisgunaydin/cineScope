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

// MARK: - File Privates
fileprivate extension AppDelegate {
    /// Configures and initializes the IQKeyboardManager settings for the app.
    ///
    /// - `keyboardDistanceFromTextField`: Sets the distance between the keyboard and the currently active text field to 20 points, ensuring enough spacing for comfortable input.
    /// - `enableAutoToolbar`: Disables the automatic toolbar above the keyboard, allowing for custom toolbar configurations if needed.
    /// - `resignOnTouchOutside`: Enables the option to dismiss the keyboard when the user taps outside the text field, improving user experience by making it easier to close the keyboard.
    /// - `enable`: Activates the IQKeyboardManager, making the configured settings effective throughout the app.
    func initializeKeyboardManager() {
        let keyboardManager = IQKeyboardManager.shared
        keyboardManager.keyboardDistanceFromTextField = 20.0
        keyboardManager.enableAutoToolbar = false
        keyboardManager.resignOnTouchOutside = true
        keyboardManager.enable = true
    }

    /// Configures and initializes the image cache settings for the app using Kingfisher.
    ///
    /// - Memory Cache:
    ///   - `totalCostLimit`: Limits the maximum memory cache size to 256 MB, helping to prevent excessive memory usage.
    ///   - `countLimit`: Limits the number of images stored in memory to 128, ensuring efficient memory management.
    ///   - `expiration`: Sets the expiration time for memory cache items to 5 minutes (300 seconds), allowing older images to be removed automatically.
    ///   - `cleanInterval`: Cleans expired memory cache items every 60 seconds, keeping memory usage optimized.
    ///
    /// - Disk Cache:
    ///   - `sizeLimit`: Limits the maximum disk cache size to 1 GB, ensuring that disk usage remains under control.
    ///   - `expiration`: Sets the expiration time for disk cache items to 7 days, with another setting mistakenly duplicated as 3 days.
    ///   - Adjust according to desired expiration period (only one expiration setting should be used).
    ///
    /// - Clean-up:
    ///   - `cleanExpiredMemoryCache()`: Cleans expired items from memory cache on app launch.
    ///   - `cleanExpiredDiskCache()`: Cleans expired items from disk cache on app launch.
    ///
    /// Finally, assigns the configured cache to the KingfisherManager's shared cache, ensuring that all image loading operations adhere to these settings.
    func initializeImageCache() {
        let cache = ImageCache.default
        
        cache.memoryStorage.config.totalCostLimit = 256 * 1024 * 1024
        cache.memoryStorage.config.countLimit = 128
        cache.memoryStorage.config.expiration = .seconds(300)
        cache.memoryStorage.config.cleanInterval = 60
        
        cache.diskStorage.config.sizeLimit = 1024 * 1024 * 1024
        cache.diskStorage.config.expiration = .days(7)
        cache.diskStorage.config.expiration = .days(3)
        
        cache.cleanExpiredMemoryCache()
        cache.cleanExpiredDiskCache()
        
        KingfisherManager.shared.cache = cache
    }
}
