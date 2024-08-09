//
//  URLRequest+Encoding.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation
import Alamofire

 extension URLRequest {
    mutating func encoded(
        encodable: Encodable,
        encoder: JSONEncoder = JSONEncoder()
    ) throws -> URLRequest {
        do {
            let encodable = AnyEncodable(encodable)
            httpBody = try encoder.encode(encodable)

            let contentTypeName = NetworkConstants.HTTPHeaderFieldKey.contentType
            let contentTypeValue = NetworkConstants.HTTPHeaderFieldValue.json
            if value(forHTTPHeaderField: contentTypeName) == nil {
                setValue(contentTypeValue, forHTTPHeaderField: contentTypeName)
            }

            return self
        } catch {
            throw NetworkError.encoding
        }
    }

    func encoded(
        parameters: [String: Any],
        parameterEncoding: ParameterEncoding
    ) throws -> URLRequest {
        do {
            return try parameterEncoding.encode(self, with: parameters)
        } catch {
            throw NetworkError.encoding
        }
    }
}
