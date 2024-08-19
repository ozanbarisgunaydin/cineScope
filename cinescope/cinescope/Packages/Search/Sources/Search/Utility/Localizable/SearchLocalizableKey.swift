//
//  SearchLocalizableKey.swift
//
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import AppResources
import Foundation

// MARK: - Typealias
typealias L10nSearch = SearchLocalizableKey

// MARK: - DetailLocalizableKey
public enum SearchLocalizableKey: String, LocalizableProtocol {
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }
    
    /// Search movies...
    case searchPlaceholder = "search.placeholder"
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

