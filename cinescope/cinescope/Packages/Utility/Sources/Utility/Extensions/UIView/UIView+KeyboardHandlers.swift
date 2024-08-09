//
//  UIView+KeyboardHandlers.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit

public extension UIView {
    func addKeyboardDismissHandler() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(
                target: self,
                action: #selector(dismissKeyboard)
            )
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        endEditing(true)
    }
}

public extension UIViewController {
    func addKeyboardDismissHandler() {
        view.addKeyboardDismissHandler()
    }

    @objc func dismissKeyboard() {
        view.dismissKeyboard()
    }
}
