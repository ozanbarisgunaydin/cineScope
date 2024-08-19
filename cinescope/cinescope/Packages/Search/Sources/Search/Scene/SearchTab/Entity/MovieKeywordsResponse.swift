//
//  MovieKeywordsResponse.swift
//
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import Foundation

// MARK: - MovieKeywordsResponse
struct MovieKeywordsResponse: Codable {
    public let id: Int?
    public let keywords: [MovieKeyword]?
}

// MARK: - MovieKeyword
struct MovieKeyword: Codable {
    let id: Int?
    let name: String?
}
