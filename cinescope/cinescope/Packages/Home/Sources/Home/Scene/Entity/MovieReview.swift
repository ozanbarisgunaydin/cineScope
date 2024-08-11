//
//  MovieReview.swift
//
//
//  Created by Ozan Barış Günaydın on 11.08.2024.
//

import Foundation

// MARK: - MovieReview
struct MovieReview: Hashable, Codable {
    let id: String?
    let author: String?
    let authorDetails: AuthorDetails?
    let content: String?
    let createdAt: String?
    let iso6391: String?
    let mediaId: Int?
    let mediaTitle: String?
    let mediaType: String?
    let updatedAt: String?
    let url: String?
    
    init(
        id: String? = nil,
        author: String? = nil,
        authorDetails: AuthorDetails? = nil,
        content: String? = nil,
        createdAt: String? = nil,
        iso6391: String? = nil,
        mediaId: Int? = nil,
        mediaTitle: String? = nil,
        mediaType: String? = nil,
        updatedAt: String? = nil,
        url: String? = nil,
        identifier: UUID = UUID()
    ) {
        self.id = id
        self.author = author
        self.authorDetails = authorDetails
        self.content = content
        self.createdAt = createdAt
        self.iso6391 = iso6391
        self.mediaId = mediaId
        self.mediaTitle = mediaTitle
        self.mediaType = mediaType
        self.updatedAt = updatedAt
        self.url = url
        self.identifier = identifier
    }
    
    // MARK: - Hashable
    var identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

// MARK: - MovieReview
struct AuthorDetails: Hashable, Codable {
    let name: String?
    let username: String?
    let avatarPath: String?
    let rating: Int?
    
    // MARK: - Hashable
    var identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
