//
//  SplashImages+Style.swift
//
//
//  Created by Ozan Barış Günaydın on 12.08.2024.
//

import UIKit.UIImage

public extension UIImage {
    static var splashBackground: UIImage? {
        return UIImage(named: "splashBackground", in: Bundle.module, compatibleWith: .current)
    }
}
