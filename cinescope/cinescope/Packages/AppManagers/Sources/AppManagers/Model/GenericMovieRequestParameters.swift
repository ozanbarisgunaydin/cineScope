//
//  GenericMovieRequestParameters.swift
//
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import Foundation

// MARK: - GenericMovieRequestParameters
struct GenericMovieRequestParameters: Encodable {
    // MARK: - Parameters
    let includeAdult: Bool
    let includeVideo: Bool
    
    // MARK: - Init
    init(
        includeAdult: Bool = false,
        includeVideo: Bool = false
    ) {
        self.includeAdult = includeAdult
        self.includeVideo = includeVideo
    }
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case includeAdult = "include_adult"
        case includeVideo = "include_video"
    }
    
    // MARK: - Encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(includeAdult.stringValue, forKey: .includeAdult)
        try container.encode(includeVideo.stringValue, forKey: .includeVideo)
    }
}

// MARK: - Boolean String
extension Bool {
    var stringValue: String {
        return self ? "true" : "false"
    }
}
