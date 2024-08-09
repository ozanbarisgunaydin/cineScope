//
//  AppStatusObserver.swift
//
//
//  Created by Ozan Barış Günaydın on 17.12.2023.
//

import UIKit

// MARK: - AppStatusObserver
@objc public protocol AppStatusObserver {
    @objc optional func appWillEnterForeground()
    @objc optional func applicationDidEnterBackground()
    @objc optional func appDidBecomeActiveNotification()
}

public extension AppStatusObserver {
    func addAppStatusObservers() {
        if appWillEnterForeground != nil {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(appWillEnterForeground),
                name: UIApplication.willEnterForegroundNotification,
                object: nil
            )
        }
        if applicationDidEnterBackground != nil {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(applicationDidEnterBackground),
                name: UIApplication.didEnterBackgroundNotification,
                object: nil
            )
        }

        if appDidBecomeActiveNotification != nil {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(appDidBecomeActiveNotification),
                name: UIApplication.didBecomeActiveNotification,
                object: nil
            )
        }
    }
    func removeAppStatusObservers() {
        if appWillEnterForeground != nil {
            NotificationCenter.default.removeObserver(UIApplication.willEnterForegroundNotification)
        }
        if applicationDidEnterBackground != nil {
            NotificationCenter.default.removeObserver(UIApplication.didEnterBackgroundNotification)
        }

        if appDidBecomeActiveNotification != nil {
            NotificationCenter.default.removeObserver(UIApplication.didBecomeActiveNotification)
        }
    }
}
