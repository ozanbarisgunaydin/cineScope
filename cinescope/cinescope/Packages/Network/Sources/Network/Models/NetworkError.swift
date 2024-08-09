//
//  NetworkError.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation
import Alamofire

// MARK: - NetworkError
public enum NetworkError: Error {
    case decoding(error: AFError)
    case encoding
    case missingURL
    case badRequest(_ data: Data?)
    case auth(_ data: Data?)
    case forbidden(_ data: Data?)
    case notFound(_ data: Data?)
    case invalidMethod(_ data: Data?)
    case timeout(_ data: Data?)
    case requestCancelled(_ data: Data?)
    case noInternetConnection
    case internalServerError(_ data: Data?)
    case unknown
    case error(AFError)
}
