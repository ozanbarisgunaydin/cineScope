//
//  Encodable+Extensions.swift
//
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            return nil
        }
        guard let dictionary = try? JSONSerialization.jsonObject(
            with: jsonData,
            options: .allowFragments
        ) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}
