//
//  BaseResponse.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 24.03.2023.
//

import Foundation

public struct BaseResponse<T: Decodable> {
    public var processStatus: ProcessStatus?
    public var friendlyMessage: FriendlyMessage?
    public var serverTime: Int?
}

// MARK: - Codable
extension BaseResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case processStatus
        case friendlyMessage
        case serverTime
    }

    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)

        processStatus = try keyedContainer.decodeIfPresent(ProcessStatus.self, forKey: .processStatus)
        friendlyMessage = try keyedContainer.decodeIfPresent(FriendlyMessage.self, forKey: .friendlyMessage)
        serverTime = try keyedContainer.decodeIfPresent(Int.self, forKey: .serverTime)
    }
}
