//
//  AppRouter+URL.swift
//
//
//  Created by Ozan Barış Günaydın on 14.08.2024.
//

import Foundation
import SafariServices

extension AppRouter {
    public func routeToSafariController(with urlString: String) {
        guard let url = URL(string: urlString),
              let controller = UIApplication.topViewController() else { return }
                
        let safariController = SFSafariViewController(url: url)
        controller.present(safariController, animated: true)
    }
}
