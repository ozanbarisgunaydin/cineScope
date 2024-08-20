//
//  FavoritesContentModel.swift
//
//
//  Created by Ozan Barış Günaydın on 20.08.2024.
//

import AppManagers
import Foundation

// MARK: - FavoritesContentModel
class FavoritesContent {
    let sectionType: FavoritesSectionType
    var items: [FavoritesItemType]
    
    init(
        sectionType: FavoritesSectionType,
        items: [FavoritesItemType]
    ) {
        self.sectionType = sectionType
        self.items = items
    }
}

// MARK: - SearchSectionType
enum FavoritesSectionType: Hashable {
    // MARK: - Cases
    case movieList
    
    // MARK: - Hashable
    var identifier: String {
        switch self {
        case .movieList:
            return "movieList"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

// MARK: - SearchItemType
enum FavoritesItemType: Hashable {
    case movie(cellContent: FavoriteCellContent)
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        switch self {
        case .movie(let cellContent):
            hasher.combine(cellContent.id)
        }
    }
}
