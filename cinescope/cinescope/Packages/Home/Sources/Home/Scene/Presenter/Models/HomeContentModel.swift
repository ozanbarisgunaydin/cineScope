//
//  HomeContentModel.swift
//
//
//  Created by Ozan Barış Günaydın on 11.08.2024.
//

import AppResources
import Foundation
import UIKit.UIImage

// MARK: - HomeContent
class HomeContent {
    let sectionType: HomeSectionType
    let items: [HomeItemType]
    
    init(
        sectionType: HomeSectionType,
        items: [HomeItemType]
    ) {
        self.sectionType = sectionType
        self.items = items
    }
}

// MARK: - HomeSectionType
enum HomeSectionType: Hashable {
    // MARK: - Cases
    case genreList(headerTitle: String? = nil)
    case categories(headerTitle: String? = nil)
    case celebrities(headerTitle: String? = nil)
    
    // MARK: - Hashable
    var identifier: String {
        switch self {
        case .genreList:
            return "genreList"
        case .categories:
            return "categories"
        case .celebrities:
            return "celebrities"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

// MARK: - HomeItemType
enum HomeItemType: Hashable {
    case genre(cellContent: GenreType)
    case category(cellContent: CategoryType)
    case person(cellContent: PersonContentModel)
}

// MARK: - HomeGenreListContent
struct HomeGenreListContent: Hashable {
    public let image: UIImage?
    public let title: String?
    public var badge: String?
    
    public init(
        image: UIImage? = nil,
        title: String? = nil,
        badge: String? = nil
    ) {
        self.image = image
        self.title = title
        self.badge = badge
    }
    
    // MARK: - Hashable
    let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

// MARK: - CategoryType
enum CategoryType: Int, Hashable {
    // MARK: - Cases
    case nowPlaying = 0
    case popular = 1
    case topRated = 2
    case upComing = 3
    
    // MARK: - Propeties
    var coverImage: UIImage? {
        switch self {
        case .nowPlaying:
            return .nowPlayingCover
        case .popular:
            return .popularCover
        case .topRated:
            return .topRatedCover
        case .upComing:
            return .upComingCover
        }
    }
    
    var title: String {
        switch self {
        case .nowPlaying:
            L10nCategory.nowPlaying.localized()
        case .popular:
            L10nCategory.popular.localized()
        case .topRated:
            L10nCategory.topRated.localized()
        case .upComing:
            L10nCategory.upComing.localized()
        }
    }    
    
    // MARK: - Hashable    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
