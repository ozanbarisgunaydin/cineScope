//
//  NetworkingConstants.swift
//
//
//  Created by Ozan Barış Günaydın on 10.08.2024.
//

import Foundation

public enum NetworkingConstants {
    public enum BaseURL {
        /// `https://api.themoviedb.org/3`
        public static let service = "https://api.themoviedb.org/3"
        
        public enum Image {
            /// Width: `200`
            public static let small = "https://image.tmdb.org/t/p/w200"
            /// Width: `300`
            public static let medium = "https://image.tmdb.org/t/p/w300"
            /// Width: `500`
            public static let large = "https://image.tmdb.org/t/p/w500"
        }
    }
}
