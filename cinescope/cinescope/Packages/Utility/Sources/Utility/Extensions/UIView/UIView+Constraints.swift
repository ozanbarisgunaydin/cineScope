//
//  UIView+Constraints.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit.UIView

public extension UIView {
    func fillToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview else {  return }
        let left = leftAnchor.constraint(equalTo: superview.leftAnchor)
        let right = rightAnchor.constraint(equalTo: superview.rightAnchor)
        let top = topAnchor.constraint(equalTo: superview.topAnchor)
        let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        NSLayoutConstraint.activate([left, right, top, bottom])
    }
    
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
}
