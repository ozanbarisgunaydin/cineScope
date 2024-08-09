//
//  BaseNavigationController.swift
//  
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import UIKit

open class BaseNavigationController: UINavigationController {
    // MARK: - Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = false
    }
    
    // MARK: - Overrides
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
}
