//
//  GenreListResponse.swift
//
//
//  Created by Ozan Barış Günaydın on 11.08.2024.
//

import AppManagers
import Foundation
import UIKit.UIImage

// MARK: - GenreListResponse
struct GenreListResponse: Codable {
    let genres: [Genre]?
}

// MARK: - HomeGenre
struct HomeGenre: Codable {
    let id: Int?
    let name: HomeGenreType?
}

// MARK: - HomeGenreListContent
enum HomeGenreType: String, Codable, Hashable {
    // MARK: - Cases
    case action = "Action"
    case adventure = "Adventure"
    case animation = "Animation"
    case comedy = "Comedy"
    case crime = "Crime"
    case documentary = "Documentary"
    case drama = "Drama"
    case family = "Family"
    case fantasy = "Fantasy"
    case history = "History"
    case horror = "Horror"
    case music = "Music"
    case mystery = "Mystery"
    case romance = "Romance"
    case scienceFiction = "Science Fiction"
    case tvMovie = "TV Movie"
    case thriller = "Thriller"
    case war = "War"
    case western = "Western"
    
    case unknown
    
    // MARK: - Propeties
    var image: UIImage? {
        switch self {
        case .action:
            return .actionGenre
        case .adventure:
            return .adventureGenre
        case .animation:
            return .animationGenre
        case .comedy:
            return .comedyGenre
        case .crime:
            return .crimeGenre
        case .documentary:
            return .documentaryGenre
        case .drama:
            return .dramaGenre
        case .family:
            return .familyGenre
        case .fantasy:
            return .fantasyGenre
        case .history:
            return .historyGenre
        case .horror:
            return .horrorGenre
        case .music:
            return .musicGenre
        case .mystery:
            return .mysteryGenre
        case .romance:
            return .romanceGenre
        case .scienceFiction:
            return .scienceFictionGenre
        case .tvMovie:
            return .tvMovieGenre
        case .thriller:
            return .thrillerGenre
        case .war:
            return .warGenre
        case .western:
            return .westernGenre
        case .unknown:
            return .unknownGenre
        }
    }
    
    // MARK: - Init
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = HomeGenreType(rawValue: rawValue) ?? .unknown
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.rawValue)
    }
}
