//
//  BaseListResponse.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation

public struct BaseListResponse<T: Decodable> {
    public var page: Int?
    public var results: T?
    public var totalPages: Int?
    public var totalResults: Int?
    public var friendlyMessage: FriendlyMessage?
}

// MARK: - Codable
extension BaseListResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case friendlyMessage
    }

    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        page = try keyedContainer.decodeIfPresent(Int.self, forKey: .page)
        results = try keyedContainer.decodeIfPresent(T.self, forKey: .results)
        totalPages = try keyedContainer.decodeIfPresent(Int.self, forKey: .totalPages)
        totalResults = try keyedContainer.decodeIfPresent(Int.self, forKey: .totalResults)
        friendlyMessage = try keyedContainer.decodeIfPresent(FriendlyMessage.self, forKey: .friendlyMessage)
    }
}
