//
//  BaseRequest.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation
import Alamofire

public struct BaseRequest: RouterProtocol {
    public var baseURL: URL
    public var path: String?
    public var method: HTTPMethod
    public var headers: HTTPHeaders
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    public var timeout: TimeInterval = 60.0
    public var task: HTTPTask
}
