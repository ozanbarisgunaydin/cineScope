//
//  TabBarLocalizableKey.swift
//
//
//  Created by Ozan Barış Günaydın on 18.12.2023.
//

import Foundation
import AppResources

// MARK: - TabBarLocalizableKey
public enum TabBarLocalizableKey: String, LocalizableProtocol {
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }
    /// Home
    case home
    /// Search
    case search
    /// Favorites
    case favorites
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
