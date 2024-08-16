//
//  SearchContent.swift
//
//
//  Created by Ozan Barış Günaydın on 17.08.2024.
//

import Foundation

// MARK: - SearchContent
class SearchContent {
    let sectionType: SearchSectionType
    let items: [SearchItemType]
    
    init(
        sectionType: SearchSectionType,
        items: [SearchItemType]
    ) {
        self.sectionType = sectionType
        self.items = items
    }
}

// MARK: - SearchSectionType
enum SearchSectionType: Hashable {
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
enum SearchItemType: Hashable {
    case movie(cellContent: MovieListCellContent)
}

// MARK: - MovieListCellContent
struct MovieListCellContent: Hashable {
    let id: Int?
    let title: String?
    let posterURL: String?
    let year: String?
    let vote: String?
}
