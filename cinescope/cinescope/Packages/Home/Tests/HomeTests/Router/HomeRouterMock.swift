//
//  HomeRouterMock.swift
//
//
//  Created by Ozan Barış Günaydın on 22.08.2024.
//

import AppManagers
import Components
import Foundation
@testable import Home

// MARK: - HomeRouterMock
final class HomeRouterMock: BaseRouter {
    // MARK: - Test Indicators
    var calledMovieID: Int?
    var calledGenre: Genre?
    var calledCategoryType: CategoryType?
    var calledPeople: PeopleContent?

    // MARK: - Overrides
    override func navigate(_ route: AppRoutes) {
        switch route {
        case .detail(let id):
            calledMovieID = id
        case .search(type: let type):
            switch type {
            case .genres(let content):
                calledGenre = Genre(id: Int(content.id ?? ""), name: content.title )
        
            case .people(content: let people):
                calledPeople = PeopleContent(id: Int(people.id ?? ""), name: people.title)
                
            case .nowPlaying:
                calledCategoryType = .nowPlaying
            case .popular:
                calledCategoryType = .popular
            case .topRated:
                calledCategoryType = .topRated
            case .upComing:
                calledCategoryType = .upComing
            default:
                break
            }
        default:
            break
        }
    }
}
