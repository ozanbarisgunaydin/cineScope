//
//  PersonContentModel.swift
//
//
//  Created by Ozan Barış Günaydın on 11.08.2024.
//

import Foundation

// MARK: - PersonContentModel
struct PersonContentModel: Hashable, Codable {
    let artistName: String?
    let profileImageURL: String?
    let knownedMoviePosters: [String?]
    
    // MARK: - Hashable
    var identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
