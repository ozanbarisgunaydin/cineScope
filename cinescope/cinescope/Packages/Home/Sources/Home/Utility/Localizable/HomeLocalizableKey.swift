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
    /// Celebrities
    case celebrities = "home.celebrities"
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
