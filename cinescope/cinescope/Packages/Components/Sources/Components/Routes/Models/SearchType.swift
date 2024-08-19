//
//  SearchType.swift
//
//
//  Created by Ozan Barış Günaydın on 17.08.2024.
//

import Foundation

// MARK: - SearchType
public enum SearchType {
    // MARK: - Cases
    case query(text: String)
    case company(content: NonQuerySearh)
    case genres(content: NonQuerySearh)
    case people(content: NonQuerySearh)
    case nowPlaying
    case popular
    case topRated
    case upComing

    // MARK: - Request Parameters
    public var parameter: [String: Any] {
        switch self {
        case .query(let text):
            ["query": text]
        case .company(let content):
            ["with_companies": content.id ?? ""]
        case .genres(let content):
            ["with_genres": content.id ?? ""]
        case .people(let content):
            ["with_people": content.id ?? ""]
        default:
            [:]
        }
    }
}

// MARK: - Non Query Search
public struct NonQuerySearh {
    public let id: String?
    public let title: String?
    
    public init(
        id: String?,
        title: String?
    ) {
        self.id = id
        self.title = title
    }
}
