//
//  BaseError.swift
//
//
//  Created by Ozan Barış Günaydın on 11.08.2024.
//

import Foundation

public struct BaseError: Error {
    public let friendlyMessage: FriendlyMessage?
    
    public init(friendlyMessage: FriendlyMessage?) {
        self.friendlyMessage = friendlyMessage
    }
}
