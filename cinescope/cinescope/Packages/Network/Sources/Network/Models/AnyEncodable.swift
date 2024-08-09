//
//  AnyEncodable.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation

public struct AnyEncodable: Encodable {
    private let encodable: Encodable

    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }

    public func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
