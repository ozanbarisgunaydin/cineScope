//
//  GenreListEntity.swift
//
//
//  Created by Ozan Barış Günaydın on 11.08.2024.
//

import AppManagers
import Foundation

// MARK: - GenreListEntity
struct GenreListEntity: Codable {
    let genres: [Genre]?
}

// MARK: - HomeGenre
struct HomeGenre: Codable {
    let id: Int?
    let name: GenreType?
}
