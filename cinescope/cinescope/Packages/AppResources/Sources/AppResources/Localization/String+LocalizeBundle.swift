//
//  String+LocalizeBundle.swift
//
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Foundation

/// bundle friendly extension
public extension String {
    func localized(in bundle: Bundle? = AppResources.bundle) -> String {
        return localized(using: nil, in: bundle)
    }

    func localizedFormat(arguments: CVarArg..., in bundle: Bundle? = AppResources.bundle) -> String {
        return String(format: localized(in: bundle), arguments: arguments)
    }

    func localizedPlural(argument: CVarArg, in bundle: Bundle? = AppResources.bundle) -> String {
        return NSString.localizedStringWithFormat(localized(in: bundle) as NSString, argument) as String
    }
}
