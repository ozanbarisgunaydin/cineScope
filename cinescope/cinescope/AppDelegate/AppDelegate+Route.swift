//
//  AppDelegate+Route.swift
//  oleytjk
//
//  Created by Ozan Barış Günaydın on 28.03.2024.
//

import UIKit
import AppResources
import FirebaseDynamicLinks
import DeepLink

extension AppDelegate {
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        let intentedForFirebase = application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: ""
        )

        guard !intentedForFirebase else { return true }
        return false
    }

    func application(
        _ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any
    ) -> Bool {
        if DeeplinkConstants.baseScheme == url.scheme {
            handleDeepLink(url)
            return true
        }

        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            handleURLDynamicLink(dynamicLink)
            return true
        }

        return false
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        if let url = userActivity.webpageURL {
            var urlHandled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, error in
                guard error == nil else { return }
                if let dynamicLink {
                    self.handleURLDynamicLink(
                        dynamicLink,
                        shouldFetchDeeplinkUrl: true
                    )
                }
            }

            if !urlHandled {
                handleWebPage(url)
                urlHandled = true
            }

            return urlHandled
        }
        return false
    }

    func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        guard let userInfo = shortcutItem.userInfo else { return }
        handleDeeplinkPush(userInfo)
    }
}


// MARK: - Deeplink
extension AppDelegate {
    func handleDeeplinkPush(_ userInfo: [AnyHashable: Any]) {
        let data = userInfo as? [String: Any?]

        if let customContent = data?["custom"] as? [String: Any?],
           let url = deeplinkURL(from: customContent) {
            handleDeepLink(url)
        }
    }

    private func deeplinkURL(from payload: [String: Any?]?, key: String? = nil) -> URL? {
        var data = payload

        if let key {
            data = payload?[key] as? [String: Any]
        }

        guard let urlString = data?[DeeplinkConstants.oneSignalDeeplinkKey] as? String,
              let url = URL(string: urlString),
              let newUrl = url.setScheme(DeeplinkConstants.baseScheme) else { return nil }

        return newUrl
    }

    private func handleURLDynamicLink(_ dynamicLink: DynamicLink, shouldFetchDeeplinkUrl: Bool = false) {
        guard let url = dynamicLink.url else { return }
        handleDeepLink(url)
    }

    func handleDeepLink(_ url: URL) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            DeepLinkManager.shared.cachedURL = url
            if DeeplinkConstants.deeplinkPrefixes.first(where: { url.absoluteString.hasPrefix($0) }) == nil {
                DeepLinkManager.shared.registerWebLinkURL(url)
            }
            DeepLinkManager.shared.router.handle(url, withCompletion: nil)
        }
    }

    func handleWebPage(_ url: URL?) {
        guard let newUrl = url?.setScheme(DeeplinkConstants.baseScheme) else { return }
        handleDeepLink(newUrl)
    }
}
