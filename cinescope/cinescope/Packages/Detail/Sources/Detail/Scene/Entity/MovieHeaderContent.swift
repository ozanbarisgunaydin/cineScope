//
//  MovieHeaderContent.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import Foundation

// MARK: - MovieHeaderContent
struct MovieHeaderContent {
    // MARK: - Properties
    var title: String?
    var originalTitle: String?
    var posterImageURL: String?
    var releaseDate: String?
    var budget: String?
    var revenue: String?
    var vote: VoteContent?
    
    // MARK: - Init
    init(
        title: String? = nil,
        originalTitle: String? = nil,
        posterImageURL: String? = nil,
        releaseDate: String? = nil,
        budget: String? = nil,
        revenue: String? = nil,
        vote: VoteContent? = nil
    ) {
        self.title = title
        self.originalTitle = originalTitle
        self.posterImageURL = posterImageURL
        self.releaseDate = releaseDate
        self.budget = budget
        self.revenue = revenue
        self.vote = vote
    }
}
