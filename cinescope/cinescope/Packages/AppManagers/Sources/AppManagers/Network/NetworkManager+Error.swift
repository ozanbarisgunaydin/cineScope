//
//  NetworkManager+Error.swift
//
//
//  Created by Ozan Barış Günaydın on 16.01.2024.
//

import UIKit
import Network
import AppResources

// MARK: - BaseResponseError + FriendlyMessage
public extension BaseResponseError {
    // MARK: - Private Variables
    private var defaultTitle: String {
        return L10nError.title.localized()
    }
    private var defaultMessage: String {
        return L10nError.message.localized()
    }
    private var defaultButton: String {
        return L10nGeneric.okay.localized()
    }

    private var title: String? {
        switch error {
        case .noInternetConnection:
            return L10nError.connectionTitle.localized()
        default:
            return defaultTitle
        }
    }

    private var message: String? {
        guard let fetchedMessage = response?.friendlyMessage?.message else {
            switch error {
            case .decoding(let error):
                print("⭕️ \(String(describing: error.underlyingError))")
                return defaultMessage
            case .timeout:
                return L10nError.timeoutMessage.localized()
            case .noInternetConnection:
                return L10nError.connectionMessage.localized()
            default:
                return defaultMessage
            }
        }

        return fetchedMessage
    }

    // MARK: - Publics
    var updatedFriendlyMessage: FriendlyMessage? {
        return FriendlyMessage(
            title: title,
            message: message
        )
    }
}

// MARK: - BaseResponse + FriendlyMessage
public extension BaseListResponse {
    // MARK: - Private Variables
    private var defaultTitle: String {
        return L10nError.title.localized()
    }
    private var defaultMessage: String {
        return L10nError.message.localized()
    }
    private var defaultButton: String {
        return L10nGeneric.okay.localized()
    }

    private var title: String? {
        return defaultTitle
    }

    private var message: String? {
        guard let fetchedMessage = friendlyMessage?.message else {
            return defaultMessage
        }

        return fetchedMessage
    }

    // MARK: - Publics
    var updatedFriendlyMessage: FriendlyMessage? {
        return FriendlyMessage(
            title: title,
            message: message
        )
    }
}
