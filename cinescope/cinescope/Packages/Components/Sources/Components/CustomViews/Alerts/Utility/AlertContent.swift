//
//  AlertContent.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import AppResources
import Network
import UIKit

// MARK: - AlertContent
public struct AlertContent {
    // MARK: - Variables
    var style: AlertStyle
    var title: String?
    var message: String?
    var asset: UIImage?
    var actions: [AlertAction]?
    var dismissStyle: DismissStyle
    var shouldDismissHandler: ((AlertAction?) -> Bool)?
    var selectedActionHandler: ((AlertAction) -> Void)?
    var selectedActionCompletionHandler: ((AlertAction) -> Void)?
    var outsideTapHandler: (() -> Void)?
    var closeTapHandler: (() -> Void)?
    var shouldBringToFront: Bool?
    var shouldGoBackOnDismiss: Bool?

    // MARK: - Init
    public init(
        style: AlertStyle = .popup,
        title: String? = nil,
        message: String? = nil,
        asset: UIImage? = nil,
        actions: [AlertAction]? = nil,
        dismissStyle: DismissStyle = .none,
        shouldDismissHandler: ((AlertAction?) -> Bool)? = nil,
        selectedActionHandler: ((AlertAction) -> Void)? = nil,
        selectedActionCompletionHandler: ((AlertAction) -> Void)? = nil,
        outsideTapHandler: (() -> Void)? = nil,
        closeTapHandler: (() -> Void)? = nil,
        shouldBringToFront: Bool? = nil,
        shouldGoBackOnDismiss: Bool? = false
    ) {
        self.style = style
        self.title = title
        self.message = message
        self.asset = asset
        self.actions = actions
        self.dismissStyle = dismissStyle
        self.shouldDismissHandler = shouldDismissHandler
        self.selectedActionHandler = selectedActionHandler
        self.selectedActionCompletionHandler = selectedActionCompletionHandler
        self.outsideTapHandler = outsideTapHandler
        self.closeTapHandler = closeTapHandler
        self.shouldBringToFront = shouldBringToFront
        self.shouldGoBackOnDismiss = shouldGoBackOnDismiss
    }
    
    public mutating func update(
        with message: FriendlyMessage? = nil,
        asset: UIImage? = .circleError,
        style: AlertStyle? = .bottomSheet,
        dismissStyle: DismissStyle? = nil,
        shouldGoBackOnDismiss: Bool? = nil
    ) {
        if let message {
            self.title = message.title
            self.message = message.message
        }
        
        if let asset {
            self.asset = asset
        }
        
        if let style {
            self.style = style
        }
        
        if let dismissStyle {
            self.dismissStyle = dismissStyle
        }
        
        if let shouldGoBackOnDismiss {
            self.shouldGoBackOnDismiss = shouldGoBackOnDismiss
        }
    }
}
