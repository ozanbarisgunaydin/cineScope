//
//  FriendlyMessage.swift
//
//
//  Created by Ozan Barış Günaydın on 20.12.2023.
//

import Foundation

public struct FriendlyMessage: Codable, Equatable {
    public let title: String?
    public let message: String?

    public init(
        title: String?,
        message: String?
    ) {
        self.title = title
        self.message = message
    }
}
