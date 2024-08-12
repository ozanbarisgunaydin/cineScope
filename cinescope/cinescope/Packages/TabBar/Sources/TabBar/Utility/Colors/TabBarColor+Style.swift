//
//  TabBarColor+Style.swift
//
//
//  Created by Ozan Barış Günaydın on 12.08.2024.
//

import UIKit.UIColor

public extension UIColor {
    // MARK: - Theme
    /// #181818
    static var curveBackground: UIColor {
        return UIColor(named: "curveBackground", in: Bundle.module, compatibleWith: .current) ?? UIColor.black
    }
}
