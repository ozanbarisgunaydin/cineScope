//
//  Genre.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import Foundation

// MARK: - Genre
public struct Genre: Equatable, Codable {
    public let id: Int?
    public let name: String?
    
    public init(
        id: Int? = nil,
        name: String? = nil
    ) {
        self.id = id
        self.name = name
    }
}
