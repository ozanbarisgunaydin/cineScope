//
//  BaseResponseError.swift
//
//
//  Created by Ozan Barış Günaydın on 22.12.2023.
//

import Foundation
import Alamofire

// MARK: - BaseResponseError
public struct BaseResponseError<T: Decodable>: Error {
    // MARK: - Variables
    public let error: NetworkError
    public let response: BaseListResponse<T>?

    // MARK: - Init
    public init(error: NetworkError) {
        self.error = error
        self.response = nil
    }

    public init(
        dataResponse: AFDataResponse<T>,
        error: NetworkError
    ) {
        self.error = error

        guard let data = dataResponse.data else {
            self.response = nil
            return
        }

        self.response = BaseListResponse<T>(from: data)
    }
}
