//
//  MovieAPI.swift
//
//
//  Created by Ozan Barış Günaydın on 25.12.2023.
//
import Alamofire
import AppResources
import Network

public enum MovieAPI: MovieRouter {
    case getPopularMovies
    case getMovieGenreList
    case getPeopleList
    case getDetail(movieID: Int)
    case getSimilarMovies(movieID: Int)
    case getDiscoveredMovies(parameters: [String: Any])
    case getNowPlayingMovies(parameters: [String: Any])
    case getPopularSearchMovies(parameters: [String: Any])
    case getTopRatedMovies(parameters: [String: Any])
    case getUpComingMovies(parameters: [String: Any])
    case getSearchedMovies(parameters: [String: Any])
    
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
        case .getSimilarMovies(let movieID):
            return "movie/\(movieID)/similar"
        case .getDiscoveredMovies:
            return "discover/movie"
        case .getNowPlayingMovies:
            return "movie/now_playing"
        case .getPopularSearchMovies:
            return "movie/popular"
        case .getTopRatedMovies:
            return "movie/top_rated"
        case .getUpComingMovies:
            return "movie/upcoming"
        case .getSearchedMovies:
            return "search/movie"
        }
    }

    public var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    public var task: HTTPTask {
        var genericParameters = GenericMovieRequestParameters().asDictionary() ?? [:]
        
        switch self {
        case let .getDiscoveredMovies(queryParameters),
             let .getNowPlayingMovies(queryParameters),
             let .getPopularSearchMovies(queryParameters),
             let .getTopRatedMovies(queryParameters),
             let .getUpComingMovies(queryParameters),
             let .getSearchedMovies(queryParameters):
            genericParameters.merge(queryParameters) { current, new in new}
            return .requestParameters(
                parameters: genericParameters,
                encoding: URLEncoding(arrayEncoding: .noBrackets)
            )
            
        default:
            return .requestParameters(
                parameters: genericParameters,
                encoding: URLEncoding(arrayEncoding: .noBrackets)
            )
        }
    }
}
