//
//  IBDesignable+Localize.swift
//
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Foundation
import UIKit

@IBDesignable
public extension UILabel {
    @IBInspectable var localizeKey: String? {
        get {
            return self.text
        }
        set {
            DispatchQueue.main.async {
                self.text = newValue?.localized()
            }
        }
    }
}

@IBDesignable
public extension UIButton {
    @IBInspectable var localizeKey: String? {
        get {
            return self.titleLabel?.text
        }
        set {
            DispatchQueue.main.async {
                self.setTitle(newValue?.localized(), for: .normal)
            }
        }
    }
}

@IBDesignable
public extension UITextView {
    @IBInspectable var localizeKey: String? {
        get {
            return self.text
        }
        set {
            DispatchQueue.main.async {
                self.text = newValue?.localized()
            }
        }
    }
}

@IBDesignable
public extension UITextField {
    @IBInspectable var localizeKey: String? {
        get {
            return self.placeholder
        }
        set {
            DispatchQueue.main.async {
                self.placeholder = newValue?.localized()
            }
        }
    }
}

@IBDesignable
public extension UINavigationItem {
    @IBInspectable var localizeKey: String? {
        get {
            return self.title
        }
        set {
            DispatchQueue.main.async {
                self.title = newValue?.localized()
            }
        }
    }
}
