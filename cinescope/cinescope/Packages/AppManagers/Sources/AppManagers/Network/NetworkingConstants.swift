//
//  NetworkingConstants.swift
//
//
//  Created by Ozan Barış Günaydın on 10.08.2024.
//

import Foundation

public enum NetworkingConstants {
    public enum Authorization {
        public static let apiKey = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkNjA2YzU0MzNiZmJhM2YwNjgzYTE4MTUwZGUwZTI4MyIsIm5iZiI6MTcyMzMxOTgzOS42NjA2MDYsInN1YiI6IjYyMzU4NTc4ZDdjZDA2MDA0NWEyMGRkYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.3cTyRWrafTz5C4WSRw30yURCCea2mnpkeSSctsL-rcY"
    }
    
    public enum BaseURL {
        public static let service = "https://api.themoviedb.org/3"
        public static let image = "https://image.tmdb.org/t/p/w400"
    }
}
