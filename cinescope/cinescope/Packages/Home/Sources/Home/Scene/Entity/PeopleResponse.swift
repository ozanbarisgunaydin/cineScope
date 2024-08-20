//
//  PeopleResponse.swift
//
//
//  Created by Ozan Barış Günaydın on 12.08.2024.
//

import AppManagers
import Foundation

// MARK: - PeopleListResponse
struct PeopleListResponse: Codable {
    let page: Int?
    let results: [PeopleContent]?
    let totalPages: Int?
    let totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - PeopleContent
struct PeopleContent: Codable {
    // MARK: - Properties
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownFor: [Movie]?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
    }
    
    // MARK: - Init
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = try container.decodeIfPresent(Bool.self, forKey: .adult)
        self.gender = try container.decodeIfPresent(Int.self, forKey: .gender)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.knownFor = try container.decodeIfPresent([Movie].self, forKey: .knownFor)
        self.knownForDepartment = try container.decodeIfPresent(String.self, forKey: .knownForDepartment)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
        
        
        profileImageURL = if let profilePath {
            "\(NetworkingConstants.BaseURL.image)\(profilePath)"
        } else {
            nil
        }
    }
    
    // MARK: - Custom Properties
    var profileImageURL: String?
}
