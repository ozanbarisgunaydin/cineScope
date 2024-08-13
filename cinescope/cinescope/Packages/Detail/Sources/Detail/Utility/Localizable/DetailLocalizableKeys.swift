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

// MARK: - DetailLocalizableKey
public enum DetailLocalizableKey: String, LocalizableProtocol {
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }
    
    /// Movie Detail
    case title = "detail.title"
    
    
    // MARK: - Header
    public enum MovieHeader: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        ///  votes
        case votes = "movieHeader.votes"
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

