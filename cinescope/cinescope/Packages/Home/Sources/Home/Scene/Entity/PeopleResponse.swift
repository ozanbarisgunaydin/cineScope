//
//  PeopleResponse.swift
//
//
//  Created by Ozan Barış Günaydın on 12.08.2024.
//

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
    var adult: Bool?
    var gender: Int?
    var id: Int?
    var knownFor: [Movie]?
    var knownForDepartment: String?
    var name: String?
    var popularity: Double?
    var profilePath: String?
    
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
}
