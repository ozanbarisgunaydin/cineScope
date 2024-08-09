//
//  NetworkClient+Handle.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation
import Alamofire

public extension NetworkClient {
    func handle<T: Decodable>(
        error: AFError,
        responseData: AFDataResponse<T>,
        completion: @escaping NetworkCompletion<T>
    ) {
        let customError = processStatusCode(responseData: responseData, error: error)

        let errorResponse = BaseResponseError(
            dataResponse: responseData,
            error: customError
        )
        completion(.failure(errorResponse))
    }
}

// MARK: - Privates
private extension NetworkClient {
    final func processStatusCode<T: Decodable>(responseData: AFDataResponse<T>, error: AFError) -> NetworkError {
        let statusCode = responseData.response?.statusCode
        switch statusCode {
            /// Bad Request
        case 400: return .badRequest(responseData.data)
            /// Authorization
        case 401: return .auth(responseData.data)
            /// Forbidden
        case 403: return .forbidden(responseData.data)
            /// Not Found
        case 404: return .notFound(responseData.data)
            /// Invalid Method
        case 405: return .invalidMethod(responseData.data)
            /// Timeout
        case 408: return .timeout(responseData.data)
            /// Request Cancelled
        case 499: return .requestCancelled(responseData.data)
            /// Internal Server Error
        case 500: return .internalServerError(responseData.data)
            /// Default
        default: return handleDefaultCase(responseData: responseData, error: error)
        }
    }

    final func handleDefaultCase<T: Decodable>(responseData: AFDataResponse<T>, error: AFError) -> NetworkError {
        guard NetworkReachabilityManager()?.isReachable ?? false else {
            return .noInternetConnection
        }

        /// Response Serialization
        if error.isResponseSerializationError {
            return .decoding(error: error)
        } else {
        /// Default
            return .error(error)
        }
    }
}
