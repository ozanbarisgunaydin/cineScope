//
//  ProcessStatus.swift
//
//
//  Created by Ozan Barış Günaydın on 25.12.2023.
//

import Foundation

public enum ProcessStatus: String, Codable {
    case undefined = "Undefined"
    case success = "Success"
    case badRequest = "BadRequest"
    case accessDenied = "AccessDenied"
    case notFound = "NotFound"
    case error = "Error"
    case internalServerError = "InternalServerError"
    case userNotFound = "UserNotFound"
    case noUpdate = "NoUpdate"
    case softUpdate = "SoftUpdate"
    case mandatoryUpdate = "MandatoryUpdate"

    case invalidGrant = "invalidGrant"
    case invalidUserInfo = "invalidUserInfo"
    case sessionExpired = "sessionExpired"
    case timeout = "timeout"
    case lockedOut = "LockedOut"

    public init(from decoder: Decoder) throws {
        let code = try decoder.singleValueContainer().decode(String.self)
        self = ProcessStatus(rawValue: code) ?? .undefined
    }
}
