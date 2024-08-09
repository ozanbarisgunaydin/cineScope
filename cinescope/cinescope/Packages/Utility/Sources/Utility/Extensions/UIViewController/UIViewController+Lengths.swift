//
//  UIViewController+Lengths.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit.UIViewController

public extension UIViewController {
    var safeAreaHeight: CGFloat {
        let window = UIWindow.key
        let safeAreaInsets = (window?.safeAreaInsets.bottom ?? 0) + (window?.safeAreaInsets.top ?? 0)
        let tabBarHeight = tabBarController?.tabBar.height ?? 0
        return (window?.height ?? 0) - safeAreaInsets - tabBarHeight
    }
    
    var safeAreaBottomHeight: CGFloat {
        let window = UIWindow.key
        return window?.safeAreaInsets.bottom ?? 0
    }
    
    var safeAreaTopHeight: CGFloat {
        let window = UIWindow.key
        return window?.safeAreaInsets.top ?? 0
    }
}
