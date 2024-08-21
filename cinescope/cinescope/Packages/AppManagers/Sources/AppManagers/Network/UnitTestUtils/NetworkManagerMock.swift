//
//  NetworkManagerMock.swift
//
//
//  Created by Ozan Barış Günaydın on 21.08.2024.
//

import Alamofire
import Foundation
import Network

// MARK: - NetworkManagerMock
final public class NetworkManagerMock<M: Decodable>: NetworkManager {
    // MARK: - Privates
    private var isSuccess: Bool
    private var response: M?
    private var errorType: NetworkError
    
    // MARK: - Init
    public init(
        isSuccess: Bool,
        response: M? = "",
        errorType: NetworkError = .unknown
    ){
        self.isSuccess = isSuccess
        self.response = response
        self.errorType = errorType
    }
    
    // MARK: - Overrided Methods
    public override func request<R: RouterProtocol, T: Decodable>(
        router: R,
        model: T.Type,
        completion: @escaping NetworkCompletion<T>
    ) {
        if isSuccess,
           let response = response as? T {
            completion(.success(response))
        } else {
            completion(
                .failure(
                    BaseResponseError(
                        error: errorType
                    )
                )
            )
        }
    }
}
