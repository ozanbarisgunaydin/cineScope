//
//  Decodable+Extensions.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 07.08.2024.
//

import Foundation

public extension Decodable {
    init?(from data: Data, using decoder: JSONDecoder = .init()) {
        guard let parsed = try? decoder.decode(Self.self, from: data) else { return nil }
        self = parsed
    }

    init?(JSONString: String?) {
        guard let json = JSONString,
              let jsonData = json.data(using: .utf8),
              let anInstance = try? JSONDecoder().decode(Self.self, from: jsonData) else {
            return nil
        }
        self = anInstance
    }
}
