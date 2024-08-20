//
//  FavoritesLocalizableKey.swift
//
//
//  Created by Ozan Barış Günaydın on 20.08.2024.
//

import AppResources
import Foundation

// MARK: - Typealias
typealias L10nFavorites = FavoritesLocalizableKey
typealias L10nFavoritesEmpty = L10nFavorites.EmptyState

// MARK: - FavoritesLocalizableKey
enum FavoritesLocalizableKey: String, LocalizableProtocol {
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }
    
    /// Favorites
    case title = "favorites.title"
    
    // MARK: - EmptyState
    enum EmptyState: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        // MARK: - Keys
        /// There is no saved favorites.
        case title = "emptyState.title"
        /// You can review movies and pick them as favorite.
        case message = "emptyState.message"
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

