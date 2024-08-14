//
//  DetailLocalizableKey.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import AppResources
import Foundation

// MARK: - Typealias
typealias L10nDetail = DetailLocalizableKey
typealias L10nMovieHeader = L10nDetail.MovieHeader
typealias L10nMovieLinks = L10nDetail.MovieLinks
typealias L10nMovieOverview = L10nDetail.MovieOverview

// MARK: - DetailLocalizableKey
public enum DetailLocalizableKey: String, LocalizableProtocol {
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }
    
    /// Movie Detail
    case title = "detail.title"
    /// Categories
    case genres = "detail.genres"

    
    // MARK: - Header
    public enum MovieHeader: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        /// votes
        case votes = "movieHeader.votes"
        /// Budget:
        case budget = "movieHeader.budget"
        /// Revenue:
        case revenue = "movieHeader.revenue"
    }
    
    // MARK: - Links
    public enum MovieLinks: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        /// Useful Links
        case title = "movieLinks.usefulLinks"
        /// Movie Page
        case moviePage = "movieLinks.moviePage"
    }
    
    // MARK: - Links
    public enum MovieOverview: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        /// Overview
        case title = "movieOverview.title"
        /// Overview is not added. Please look up later.
        case emptyDescription = "movieOverview.emptyDescription"
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

