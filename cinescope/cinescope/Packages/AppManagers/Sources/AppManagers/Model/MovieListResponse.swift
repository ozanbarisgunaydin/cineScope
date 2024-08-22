//
//  MovieListResponse.swift
//
//
//  Created by Ozan Barış Günaydın on 10.08.2024.
//

import Foundation

// MARK: - MovieListResponse
public struct MovieListResponse: Codable {
    public let page: Int?
    public let results: [Movie]?
    public let totalPages: Int?
    public let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Movie
public struct Movie: Equatable, Codable {
    // MARK: - Properties
    public let adult: Bool?
    public let backdropPath: String?
    public let belongsToCollection: BelongsToCollection?
    public let budget: Int?
    public let genres: [Genre]?
    public let homepage: String?
    public let id: Int?
    public let imdbID: String?
    public let originCountry: [String]?
    public let originalLanguage: String?
    public let originalTitle: String?
    public let overview: String?
    public let popularity: Double?
    public let posterPath: String?
    public let productionCompanies: [ProductionCompany]?
    public let productionCountries: [ProductionCountry]?
    public let releaseDate: String?
    public let revenue: Int?
    public let runtime: Int?
    public let spokenLanguages: [SpokenLanguage]?
    public let status: String?
    public let tagline: String?
    public let title: String?
    public let video: Bool?
    public let voteAverage: Double?
    public let voteCount: Int?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbID = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    // MARK: - Init
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.belongsToCollection = try container.decodeIfPresent(BelongsToCollection.self, forKey: .belongsToCollection)
        self.budget = try container.decodeIfPresent(Int.self, forKey: .budget)
        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
        self.homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID)
        self.originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry)
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.productionCompanies = try container.decodeIfPresent([ProductionCompany].self, forKey: .productionCompanies)
        self.productionCountries = try container.decodeIfPresent([ProductionCountry].self, forKey: .productionCountries)
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        self.revenue = try container.decodeIfPresent(Int.self, forKey: .revenue)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        self.spokenLanguages = try container.decodeIfPresent([SpokenLanguage].self, forKey: .spokenLanguages)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        
        backDropImageURL = if let backdropPath {
            "\(NetworkingConstants.BaseURL.Image.small)\(backdropPath)"
        } else {
            nil
        }
        
        bannerImageURL = if let backdropPath {
            "\(NetworkingConstants.BaseURL.Image.large)\(backdropPath)"
        } else {
            nil
        }
        
        posterImageURL = if let posterPath {
            "\(NetworkingConstants.BaseURL.Image.small)\(posterPath)"
        } else {
            nil
        }
        
        largePosterImageURL = if let posterPath {
            "\(NetworkingConstants.BaseURL.Image.large)\(posterPath)"
        } else {
            nil
        }
    }
    
    // MARK: - Custom Properties
    public var backDropImageURL: String?
    public var bannerImageURL: String?
    public var posterImageURL: String?
    public var largePosterImageURL: String?
}

// MARK: - BelongsToCollection
public struct BelongsToCollection: Equatable, Codable {
    public let id: Int?
    public let name: String?
    public let posterPath: String?
    public let backdropPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - ProductionCompany
public struct ProductionCompany: Equatable, Codable {
    public let id: Int?
    public let logoPath: String?
    public let name: String?
    public let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.logoPath = try container.decodeIfPresent(String.self, forKey: .logoPath)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.originCountry = try container.decodeIfPresent(String.self, forKey: .originCountry)
        
        logoImageURL = if let logoPath {
            "\(NetworkingConstants.BaseURL.Image.small)\(logoPath)"
        } else {
            nil
        }
    }
    
    public var logoImageURL: String?
}

// MARK: - ProductionCountry
public struct ProductionCountry: Equatable, Codable {
    public let iso31661: String?
    public let name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
public struct SpokenLanguage: Equatable, Codable {
    public let englishName: String?
    public let iso6391: String?
    public let name: String?
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
        case name
    }
}
