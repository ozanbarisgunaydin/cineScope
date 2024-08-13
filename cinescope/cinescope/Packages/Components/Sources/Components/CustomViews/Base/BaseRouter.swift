//
//  BaseRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import UIKit

// MARK: - BaseRouterProtocol
public protocol BaseRouterProtocol: AnyObject {
    /// Variables
    var navigationController: UINavigationController { get set }
    var delegate: BaseRouterProtocol? { get set }
    /// Functions
    func createModule()
    func getModule() -> UIViewController
    func back()
    func navigate(_ route: AppRoutes)
}

// MARK: - BaseRouter
open class BaseRouter: NSObject, BaseRouterProtocol {
    // MARK: - Publics
    public var navigationController = UINavigationController()
    weak public var delegate: BaseRouterProtocol?

    // MARK: - Init
    public init(
        delegate: BaseRouterProtocol? = nil,
        _ navigationController: UINavigationController
    ) {
        self.delegate = delegate
        self.navigationController = navigationController
        super.init()
    }
    
    // MARK: - Module
    open func createModule() {
        fatalError("\(#function) should be implemented.")
    }    
    
    open func getModule() -> UIViewController {
        fatalError("\(#function) should be implemented.")
    }
    
    open func navigate(_ route: AppRoutes) {
        delegate?.navigate(route)
    }
    
    // MARK: - Generic Back
    public func back() {
        if let controller = navigationController.visibleViewController,
           controller.isModal {
            controller.dismiss(animated: true, completion: nil)
        } else {
            navigationController.popViewController(animated: true)
        }
    }
}
