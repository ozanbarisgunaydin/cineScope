//
//  NetworkConstants.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation

public enum NetworkConstants {
    public static var timeout: TimeInterval = 60

    /// The keys for HTTP header fields
    public enum HTTPHeaderFieldKey {
        public static let authorization = "Authorization"
        public static let contentType = "Content-Type"
        public static let acceptType = "Accept"
        public static let acceptEncoding = "Accept-Encoding"
    }

    /// The values for HTTP header fields
    public enum HTTPHeaderFieldValue {
        public static let json = "application/json"
        public static let fromEncoded = "application/x-www-form-urlencoded"
    }
}
