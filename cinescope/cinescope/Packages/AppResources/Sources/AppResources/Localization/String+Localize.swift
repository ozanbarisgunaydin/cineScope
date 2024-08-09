//
//  String+Localize.swift
//
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Foundation

public extension String {
    static func localized(_ key: LocalizableProtocol, in bundle: Bundle? = AppResources.bundle) -> String {
        return key.stringValue.localized(in: bundle)
    }

    static func localizedFormat(_ key: LocalizableProtocol, arguments: CVarArg..., in bundle: Bundle? = AppResources.bundle) -> String {
        return key.stringValue.localizedFormat(arguments: arguments, in: bundle)
    }

    static func localizedPlural(_ key: LocalizableProtocol, argument: CVarArg, in bundle: Bundle? = AppResources.bundle) -> String {
        return key.stringValue.localizedPlural(argument: argument, in: bundle)
    }
}
