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
    public let buttonPositive: String?
    public let buttonNegative: String?
    public let buttonNeutral: String?

    public init(
        title: String?,
        message: String?,
        buttonPositive: String? = nil,
        buttonNegative: String? = nil,
        buttonNeutral: String? = nil
    ) {
        self.title = title
        self.message = message
        self.buttonPositive = buttonPositive
        self.buttonNegative = buttonNegative
        self.buttonNeutral = buttonNeutral
    }
}
