//
//  MovieAPI.swift
//
//
//  Created by Ozan Barış Günaydın on 25.12.2023.
//

import Foundation
import Network
import Alamofire
import AppResources

public enum MovieAPI: MovieRouter {
    case getPopularMovies
    case getMovieGenreList
    case getPeopleList
    case getDetail(movieID: Int)

    public var path: String? {
        switch self {
        case .getPopularMovies:
            return "discover/movie"
        case .getMovieGenreList:
            return "genre/movie/list"
        case .getPeopleList:
            return "person/popular"
        case .getDetail(let movieID):
            return "movie/\(movieID)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getPopularMovies,
             .getMovieGenreList,
             .getPeopleList,
             .getDetail:
            return .get
        }
    }

    public var task: HTTPTask {
        switch self {
        case .getPopularMovies:
            let queryParameters: [String: Any] = [
                "include_adult": "false",
                "include_video": "false",
                "page": "1",
                "sort_by": "popularity"
            ]
            return .requestParameters(
                parameters: queryParameters,
                encoding: URLEncoding(arrayEncoding: .noBrackets)
            )
        case .getMovieGenreList,
             .getPeopleList,
             .getDetail:
            return .requestPlain
        }
    }
}
