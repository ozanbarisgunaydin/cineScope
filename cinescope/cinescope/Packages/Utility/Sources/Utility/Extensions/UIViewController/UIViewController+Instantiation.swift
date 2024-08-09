//
//  UIViewController+Instantiation.swift
//  
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit.UIViewController

public extension UIViewController {
    func setRootViewController(
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        options: UIView.AnimationOptions = .transitionCrossDissolve,
        _ completion: (() -> Void)? = nil
    ) {
        guard
            let appDelegateWindow = UIApplication.shared.delegate?.window,
            let window = appDelegateWindow
        else { return }
        
        guard animated else {
            window.rootViewController = self
            window.makeKeyAndVisible()
            completion?()
            return
        }
        
        UIView.transition(
            with: window,
            duration: duration,
            options: options
        ) {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            window.rootViewController = self
            window.makeKeyAndVisible()
            UIView.setAnimationsEnabled(oldState)
        } completion: { _ in
            completion?()
        }
    }
}
