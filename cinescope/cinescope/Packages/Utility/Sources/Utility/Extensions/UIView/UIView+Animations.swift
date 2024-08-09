//
//  UIView+Animations.swift
//  
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit.UIView

public extension UIView {
    func fadeIn(
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil
    ) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    func fadeOut(
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil
    ) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}
