//
//  DetailColor+Style.swift
//
//
//  Created by Ozan Barış Günaydın on 14.08.2024.
//

import UIKit.UIColor

public extension UIColor {
    /// #F6C700
    static var imdbYellow: UIColor {
        return UIColor(named: "imdbYellow", in: Bundle.module, compatibleWith: .current) ?? UIColor.white
    }
}
