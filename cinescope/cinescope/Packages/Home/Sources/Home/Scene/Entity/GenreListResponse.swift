//
//  GenreListResponse.swift
//
//
//  Created by Ozan Barış Günaydın on 11.08.2024.
//

import Foundation

// MARK: - GenreListResponse
struct GenreListResponse: Codable {
    let genres: [Genre]?
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int?
    let name: String?
}
