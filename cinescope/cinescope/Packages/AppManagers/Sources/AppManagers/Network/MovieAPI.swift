//
//  MovieAPI.swift
//
//
//  Created by Ozan Barış Günaydın on 25.12.2023.
//

import Foundation
import Network
import Alamofire
import AppResources

public enum MovieAPI: MovieRouter {
    case getUserInfo

    public var path: String? {
        switch self {
        case .getUserInfo:
            return "core/user/info"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getUserInfo:
            return .get
        }
    }

    public var task: HTTPTask {
        switch self {
        case .getUserInfo:
            return .requestPlain
        }
    }
}
