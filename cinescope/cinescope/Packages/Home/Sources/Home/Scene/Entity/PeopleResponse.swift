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
    var page: Int?
    var results: [PeopleContent]?
    var totalPages: Int?
    var totalResults: Int?
    
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
    var adult: Bool?
    var gender: Int?
    var id: Int?
    var knownFor: [Movie]?
    var knownForDepartment: String?
    var name: String?
    var popularity: Double?
    var profilePath: String?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case adult
        case gender
        case id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name
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
