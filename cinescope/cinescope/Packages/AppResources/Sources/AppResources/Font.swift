//
//  UIFont+Init.swift
//
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Foundation
import UIKit

internal extension UIFont {
    // MARK: - Fonts
    enum FontWeight: String {
        case light = "Ubuntu-Light"
        case regular = "Ubuntu-Regular"
        case medium = "Ubuntu-Medium"
        case bold = "Ubuntu-Bold"

        case lightItalic = "Ubuntu-LightItalic"
        case italic = "Ubuntu-Italic"
        case mediumItalic = "Ubuntu-MediumItalic"
        case boldItalic = "Ubuntu-BoldItalic"

        var name: String {
            rawValue
        }
    }

    // MARK: - Privates
    class func font(size: CGFloat, weight: FontWeight) -> UIFont {
        guard let font = UIFont(name: weight.name, size: size) else {
            registerFont(name: weight.name)
            return UIFont(name: weight.name, size: size) ?? UIFont.systemFont(ofSize: size)
        }
        return font
    }

    static func registerFont(name: String) {
        guard
            let pathForResourceString = Bundle.module.path(forResource: name, ofType: "ttf"),
            let fontData = NSData(contentsOfFile: pathForResourceString),
            let dataProvider = CGDataProvider(data: fontData),
            let fontRef = CGFont(dataProvider)
        else { return }
        var error: UnsafeMutablePointer<Unmanaged<CFError>?>?
        if CTFontManagerRegisterGraphicsFont(fontRef, error) == false {
            return
        }
        error = nil
    }
}
