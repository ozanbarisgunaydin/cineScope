//
//  AppDelegate+DeepLink.swift
//  oleytjk
//
//  Created by Ozan Barış Günaydın on 2.04.2024.
//

import Foundation
import UIKit
import DeepLink

extension AppDelegate: DeepLinkManagerDelegate {
    func handleAppLink(url: URL) {
        appCoordinator.handleDeepLink(url: url)
    }

    func handleWebLink(
        url: URL,
        title: String?,
        screenName: String?,
        transition: TransitionType,
        type: WebViewType
    ) {
        appCoordinator.handleWebLink(
            url: url,
            title: title,
            screenName: screenName,
            transition: transition,
            type: type
        )
    }
}
