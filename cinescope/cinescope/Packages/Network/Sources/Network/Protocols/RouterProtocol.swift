//
//  RouterProtocol.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation
import Alamofire

// MARK: - RouterProtocol
public protocol RouterProtocol: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var task: HTTPTask { get }
    var cachePolicy: URLRequest.CachePolicy { get }
    var timeout: TimeInterval { get }
}

// MARK: - URLRequest
extension RouterProtocol {
    // swiftlint:disable cyclomatic_complexity
    public func asURLRequest() throws -> URLRequest {
        var url = baseURL

        // Path
        if let path {
            url = baseURL.appendingPathComponent(path)
        }

        var request = URLRequest(url: url)

        // Method
        request.httpMethod = method.rawValue
        // Headers
        request.allHTTPHeaderFields = headers.dictionary
        // Cache Policy
        request.cachePolicy = cachePolicy
        // Timeout
        request.timeoutInterval = timeout

        // Task
        switch task {
        case .requestPlain, .uploadFile, .uploadMultipart, .downloadDestination:
            break
        case .requestData(let data):
            request.httpBody = data
        case let .requestJSONEncodable(encodable):
            request = try request.encoded(encodable: encodable)
        case let .requestCustomJSONEncodable(
            encodable,
            encoder: encoder
        ):
            request = try request.encoded(encodable: encodable, encoder: encoder)
        case let .requestParameters(parameters, parameterEncoding):
            request = try request.encoded(parameters: parameters, parameterEncoding: parameterEncoding)
        case let .uploadCompositeMultipart(_, urlParameters):
            let parameterEncoding = URLEncoding(destination: .queryString)
            request = try request.encoded(parameters: urlParameters, parameterEncoding: parameterEncoding)
        case let .downloadParameters(parameters, parameterEncoding, _):
            request = try request.encoded(parameters: parameters, parameterEncoding: parameterEncoding)
        case let .requestCompositeData(bodyData: bodyData, urlParameters: urlParameters):
            request.httpBody = bodyData
            let parameterEncoding = URLEncoding(destination: .queryString)
            request = try request.encoded(parameters: urlParameters, parameterEncoding: parameterEncoding)
        case let .requestCompositeParameters(
            bodyParameters: bodyParameters,
            bodyEncoding: bodyParameterEncoding,
            urlParameters: urlParameters
        ):
            if let bodyParameterEncoding = bodyParameterEncoding as? URLEncoding,
                bodyParameterEncoding.destination != .httpBody {
                fatalError("""
                    Only URLEncoding that `bodyEncoding` accepts is URLEncoding.httpBody. Others
                    like `default`, `queryString` or `methodDependent` are prohibited - if you want
                    to use them, add your parameters to `urlParameters` instead.
                """)
            }
            let bodyfulRequest = try request.encoded(
                parameters: bodyParameters,
                parameterEncoding: bodyParameterEncoding
            )
            let urlEncoding = URLEncoding(destination: .queryString)
            request = try bodyfulRequest.encoded(
                parameters: urlParameters,
                parameterEncoding: urlEncoding
            )
        }

        return request
    }
    // swiftlint:enable cyclomatic_complexity
}

// MARK: - Hash
extension RouterProtocol {
     var hash: Int {
        var hasher = Hasher()
        hasher.combine(baseURL)
        hasher.combine(path)
        hasher.combine(method)
        hasher.combine(headers.dictionary)
        hasher.combine(cachePolicy)
        hasher.combine(timeout)
        return hasher.finalize()
    }
}
