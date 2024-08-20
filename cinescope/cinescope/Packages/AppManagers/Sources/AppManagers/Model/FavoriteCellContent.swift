//
//  FavoriteCellContent.swift
//
//
//  Created by Ozan Barış Günaydın on 20.08.2024.
//

import Foundation

public struct FavoriteCellContent: Codable, Hashable {
    public let backdropImageURL: String?
    public let title: String?
    public let date: String?
    public let vote: String?
    public let id: Int?
    
    public init(
        backdropImageURL: String?,
        title: String?,
        date: String?,
        vote: String?,
        id: Int?
    ) {
        self.backdropImageURL = backdropImageURL
        self.title = title
        self.date = date
        self.vote = vote
        self.id = id
    }
}
