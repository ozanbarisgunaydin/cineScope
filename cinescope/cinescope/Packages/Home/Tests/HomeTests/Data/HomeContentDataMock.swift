//
//  HomeContentDataMock.swift
//
//
//  Created by Ozan Barış Günaydın on 21.08.2024.
//

import Foundation
import AppManagers
@testable import Home

final class HomeContentDataMock {
    static func getBannerContent(movieID: Int) -> [BannerContent] {
        return [
            BannerContent(
                title: "title",
                imageURL: "imageURL",
                movieID: movieID
            )
        ]
    }
    
    static func getCategoryContent(type: CategoryType) -> [HomeContent] {
        return [
            HomeContent(
                sectionType: .categories(headerTitle: "categories"),
                items: [
                    .category(cellContent: type)
                ]
            )
        ]
    }
    
    static func getGenreContent(index: Int) -> [HomeContent] {
        return [
            HomeContent(
                sectionType: .genreList(headerTitle: "genreList"),
                items: [
                    .genre(cellContent: .action)
                ]
            )
        ]
    }
    
    static func getCelebrityContent(index: Int) -> [HomeContent] {
        return [
            HomeContent(
                sectionType: .celebrities(headerTitle: "celebrities"),
                items: [
                    .person(
                        cellContent: PersonContent(
                            artistName: nil,
                            profileImageURL: nil,
                            knownedMoviePosters: []
                        )
                    )
                ]
            )
        ]
    }
    
    static let getPopularMovies = MockDataManager().getData(
        from: "popular_movies_success_response",
        type: MovieListResponse.self,
        on: Bundle.module
    )
    
    static let getMovieGenres = MockDataManager().getData(
        from: "movie_genres_success_response",
        type: GenreListResponse.self,
        on: Bundle.module
    )
    
    static let getTrendPeople = MockDataManager().getData(
        from: "movie_genres_success_response",
        type: PeopleListResponse.self,
        on: Bundle.module
    )
}
