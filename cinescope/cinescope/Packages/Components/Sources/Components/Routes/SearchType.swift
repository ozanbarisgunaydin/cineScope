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
    case company(id: String)
    
    // MARK: - Request Parameters
    public var parameter: [String: Any] {
        switch self {
        case .query(let text):
            ["query": text]
        case .company(let id):
            ["with_companies": id]
        }
    }
}
