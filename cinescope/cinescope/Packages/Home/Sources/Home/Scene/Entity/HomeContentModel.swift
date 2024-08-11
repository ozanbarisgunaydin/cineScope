//
//  HomeContentModel.swift
//
//
//  Created by Ozan Barış Günaydın on 11.08.2024.
//

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
    case genreList(headerContent: HomeGenreListContent? = nil)
    case categories(headerTitle: String? = nil)
    case reviews(headerTitle: String? = nil)
    
    // MARK: - Hashable
    var identifier: String {
        switch self {
        case .genreList:
            return "genreList"
        case .categories:
            return "categories"
        case .reviews(let title):
            if let title {
                return "reviews_\(title)"
            } else {
                return "reviews_nil"
            }
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

// MARK: - HomeItemType
enum HomeItemType: Hashable {
    case genre(cellContent: HomeGenreListContent)
    case category(cellContent: HomeCategoryModel)
    case review(cellContent: MovieReview)
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

// MARK: - HomeCategoryModel
struct HomeCategoryModel: Hashable {
    public let image: UIImage?
    public let type: CategoryType?
    
    init(
        image: UIImage? = nil,
        type: CategoryType? = nil
    ) {
        self.image = image
        self.type = type
    }
    
    // MARK: - Hashable
    let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

// MARK: - CategoryType
enum CategoryType {
    case nowPlaying
    case popular
    case topRated
    case upComing
}
