//
//  BaseRouter.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import UIKit

// MARK: - BaseRouterProtocol
@MainActor
public protocol BaseRouterProtocol: AnyObject {
    /// Variables
    var navigationController: UINavigationController { get set }
    /// Functions
    func createModule()
    func getModule() -> UIViewController
    func back()
}

// MARK: - BaseRouter
open class BaseRouter: NSObject {
    // MARK: - Publics
    public var navigationController = UINavigationController()
    
    // MARK: - Init
    public init(_ navigationController: UINavigationController) {
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
