//
//  HomeLocalizableKey.swift
//
//
//  Created by Ozan Barış Günaydın on 11.08.2024.
//

import AppResources
import Foundation

// MARK: - Typealias
public typealias L10nHome = HomeLocalizableKey
public typealias L10nHomeCategory = L10nHome.Category

// MARK: - HomeLocalizableKey
public enum HomeLocalizableKey: String, LocalizableProtocol {
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }
    
    /// Genres
    case genres = "home.genres"
    /// Discover
    case discover = "home.discover"
    
    // MARK: - Category
    public enum Category: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        /// Now Playings
        case nowPlaying = "category.nowPlaying"
        /// Populars
        case popular = "category.popular"
        /// Top Rateds
        case topRated = "category.topRated"
        /// Up Comings
        case upComing = "category.upComing"
    }
}

// MARK: - LocalizableProtocol
extension LocalizableProtocol {
    public func localized() -> String {
        let bundle = stringValue.localized(in: Bundle.module) == stringValue ? AppResources.bundle : Bundle.module
        return stringValue.localized(in: bundle)
    }
    
    public func localizedFormat(arguments: CVarArg...) -> String {
        return stringValue.localizedFormat(arguments: arguments, in: Bundle.module)
    }
    
    public func localizedPlural(argument: CVarArg) -> String {
        return stringValue.localizedPlural(argument: argument, in: Bundle.module)
    }
}
