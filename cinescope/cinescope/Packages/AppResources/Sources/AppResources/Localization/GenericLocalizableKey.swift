//
//  LocalizeKey.swift
//
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Foundation

// MARK: - LocalizableProtocol
public protocol LocalizableProtocol {
    var stringValue: String { get }

    func localized(in bundle: Bundle?) -> String
    func localizedFormat(arguments: CVarArg..., in bundle: Bundle?) -> String
    func localizedPlural(argument: CVarArg, in bundle: Bundle?) -> String

    func localized() -> String
    func localizedFormat(arguments: CVarArg...) -> String
    func localizedPlural(argument: CVarArg) -> String
}

public extension LocalizableProtocol {
    func localized(in bundle: Bundle? = AppResources.bundle) -> String {
        return self.stringValue.localized(in: bundle)
    }

    func localizedFormat(arguments: CVarArg..., in bundle: Bundle? = AppResources.bundle) -> String {
        return self.stringValue.localizedFormat(arguments: arguments, in: bundle)
    }

    func localizedPlural(argument: CVarArg, in bundle: Bundle? = AppResources.bundle) -> String {
        return self.stringValue.localizedPlural(argument: argument, in: bundle)
    }
}

// MARK: - Typealias
public typealias L10nGeneric = GenericLocalizableKey
public typealias L10nError = L10nGeneric.Error
public typealias L10nEmptyState = L10nGeneric.EmptyState
public typealias L10nCategory = L10nGeneric.Category

// MARK: - GenericLocalizableKey
public enum GenericLocalizableKey: String, LocalizableProtocol {
    // MARK: - RawValue
    public var stringValue: String {
        return rawValue
    }

    // MARK: - Keys
    /// Continue
    case `continue` = "generic.continue"
    /// Okay
    case okay = "generic.okay"
    /// Cancel
    case cancel = "generic.cancel"

    // MARK: - Error
    public enum Error: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }

        // MARK: - Keys
        /// Error Occurred
        case title = "error.title"
        /// Please try again later.
        case message = "error.message"
        /// The operation timed out. Please try again later.
        case timeoutMessage = "error.timeoutMessage"
        /// Connection Problem
        case connectionTitle = "error.connectionTitle"
        /// We detected an issue with your internet connection. Please check your settings and try to reconnect.
        case connectionMessage = "error.connectionMessage"
    }
    
    // MARK: - EmptyState
    public enum EmptyState: String, LocalizableProtocol {
        // MARK: - RawValue
        public var stringValue: String {
            return rawValue
        }
        
        // MARK: - Keys
        /// Content is not prepared.
        case title = "emptyState.title"
        /// The content will be prepared when it is ready.
        case message = "emptyState.message"
    }
    
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

// MARK: - Functions
extension LocalizableProtocol {
    public func localized() -> String {
        return stringValue.localized()
    }

    public func localizedFormat(arguments: CVarArg...) -> String {
        return stringValue.localizedFormat(arguments: arguments, in: AppResources.bundle)
    }

    public func localizedPlural(argument: CVarArg) -> String {
        return stringValue.localizedPlural(argument: argument, in: AppResources.bundle)
    }
}
