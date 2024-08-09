//
//  String+LocalizedBundleTableName.swift
//  
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Foundation

public extension String {
    func localized(using tableName: String?, in bundle: Bundle? = AppResources.bundle) -> String {
        let bundle: Bundle = bundle ?? .main
        if let path = bundle.path(forResource: Localize.currentLanguage(), ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        } else if let path = bundle.path(forResource: LocalizableBundle, ofType: "lproj"),
                let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        return self
    }

    func localizedFormat(arguments: CVarArg..., using tableName: String?, in bundle: Bundle? = AppResources.bundle) -> String {
        return String(format: localized(using: tableName, in: bundle), arguments: arguments)
    }

    func localizedPlural(argument: CVarArg, using tableName: String?, in bundle: Bundle? = AppResources.bundle) -> String {
        return NSString.localizedStringWithFormat(
            localized(using: tableName, in: bundle) as NSString, argument
        ) as String
    }
}
