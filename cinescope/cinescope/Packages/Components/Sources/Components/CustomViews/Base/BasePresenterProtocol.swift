//
//  BaseViewModel.swift
//
//
//  Created by Ozan Barış Günaydın on 6.12.2023.
//

import AppResources
import Combine
import Network
import UIKit

// MARK: - BasePresenterProtocol
public protocol BasePresenterProtocol: AnyObject {
    /// Variables
    var isLoading: PassthroughSubject<Bool, Error> { get set }
    var alert: PassthroughSubject<AlertContent?, Error> { get set }
    var cancellables: [AnyCancellable] { get set }
    var router: BaseRouterProtocol? { get set }

    /// Functions
    func showServiceFailure(
        errorMessage: FriendlyMessage?,
        shouldGoBackOnDismiss: Bool
    )
    func routeBack()
}

// MARK: - Defaults
extension BasePresenterProtocol {
    public func showServiceFailure(
        errorMessage: FriendlyMessage?,
        shouldGoBackOnDismiss: Bool = false
    ) {
        var alert = AlertContent()
        let isConnectionType = errorMessage?.message == L10nError.connectionMessage.localized()
        let asset: UIImage? = isConnectionType ? .circleConnection : .circleError
        alert.update(
            with: errorMessage,
            asset: asset,
            shouldGoBackOnDismiss: shouldGoBackOnDismiss
        )
        self.alert.send(alert)
    }
    
    public func routeBack() {
        router?.back()
    }
}

// MARK: - BasePresenter
open class BasePresenter: BasePresenterProtocol {
    // MARK: - Base Variables
    public var isLoading = PassthroughSubject<Bool, Error>()
    public var alert = PassthroughSubject<AlertContent?, Error>()
    public var cancellables: [AnyCancellable] = []
    open var router: BaseRouterProtocol?
    
    // MARK: - Init
    public init(
        router: BaseRouterProtocol? = nil
    ) {
        self.router = router
    }
}
