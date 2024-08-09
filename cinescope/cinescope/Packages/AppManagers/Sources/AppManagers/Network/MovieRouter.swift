//
//  MovieRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 25.12.2023.
//

import Foundation
import Network
import Alamofire
import AppResources

public protocol MovieRouter: RouterProtocol { }

// MARK: - Defaults
public extension MovieRouter {
    var baseURL: URL {
        guard let url = URL(string: AppResources.shared.baseURL) else {
            fatalError("Failed to create baseURL")
        }
        return url
    }

    var headers: HTTPHeaders {
        return HTTPHeaders.default
    }

    var cachePolicy: URLRequest.CachePolicy {
        return .reloadIgnoringLocalAndRemoteCacheData
    }

    var timeout: TimeInterval {
        return NetworkConstants.timeout
    }
}
