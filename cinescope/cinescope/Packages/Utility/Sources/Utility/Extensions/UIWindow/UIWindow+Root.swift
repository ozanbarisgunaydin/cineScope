//
//  UIWindow+Root.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit

public extension UIWindow {
    static var key: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    func switchRootViewController(
        to viewController: UIViewController,
        animated: Bool = true,
        duration: TimeInterval = 0.5,
        options: UIView.AnimationOptions = .transitionCrossDissolve,
        _ completion: (() -> Void)? = nil
    ) {
        guard animated else {
            rootViewController = viewController
            completion?()
            return
        }
        
        UIView.transition(
            with: self,
            duration: duration,
            options: options,
            animations: {
                let oldState = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                self.rootViewController = viewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { _ in
                completion?()
            }
        )
    }
}
