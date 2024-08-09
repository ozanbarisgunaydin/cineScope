//
//  UIViewController+Properties.swift
//  
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit.UIViewController

public extension UIViewController {
    var isVisible: Bool {
        return isViewLoaded && view.window != nil
    }
    
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if let navigationController = navigationController,
                  navigationController.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if let tabBarController = tabBarController,
                  tabBarController.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}
