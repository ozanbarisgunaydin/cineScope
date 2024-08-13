//
//  MovieListResponse.swift
//
//
//  Created by Ozan Barış Günaydın on 10.08.2024.
//

import AppManagers
import Foundation

// MARK: - MovieListResponse
struct MovieListResponse: Codable {
    let page: Int?
    let results: [Movie]?
}

// MARK: - Movie
struct Movie: Codable {
    // MARK: - Properties
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    // MARK: - Init
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.genreIDS = try container.decodeIfPresent([Int].self, forKey: .genreIDS)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        
        backDropImageURL = if let backdropPath {
            "\(NetworkingConstants.BaseURL.image)\(backdropPath)"
        } else {
            nil
        }
    }
    
    // MARK: - Custom Properties
    var backDropImageURL: String?
}
