//
//  NetworkManager.swift
//
//
//  Created by Ozan Barış Günaydın on 4.01.2024.
//

import Foundation
import Network

// MARK: - NetworkManager
public class NetworkManager {
    // MARK: - Shared
    public static var shared = NetworkManager()

    // MARK: - Privates
    private let network = NetworkClient()

    // MARK: - Publics
    /// Performs a network request using the provided router and handles authentication-related scenarios.
    ///
    /// If the user is logged in and the current access token is expired, it attempts to refresh the token
    /// and retries the original request. Otherwise, it proceeds with the original network request.
    ///
    /// - Parameters:
    ///   - router: The router conforming to `RouterProtocol` that defines the details of the network request.
    ///   - model: The type of the expected response model conforming to `Decodable`.
    ///   - completion: A closure to be executed when the network request is complete, providing a result of type `NetworkResult<T>`.
    public func request<R: RouterProtocol, T: Decodable>(
        router: R,
        model: T.Type,
        completion: @escaping NetworkCompletion<T>
    ) {
        network.request(
            router: router,
            model: model
        ) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
