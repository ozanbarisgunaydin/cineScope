//
//  Image+Style.swift
//
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Foundation
import UIKit

public extension UIImage {
    // MARK: - Circle Icon
    static var circleError: UIImage? {
        return UIImage(named: "circleError", in: Bundle.module, compatibleWith: .current)
    }
    
    static var circleInfo: UIImage? {
        return UIImage(named: "circleInfo", in: Bundle.module, compatibleWith: .current)
    }
    
    static var circleConnection: UIImage? {
        return UIImage(named: "circleConnection", in: Bundle.module, compatibleWith: .current)
    }
    
    // MARK: - Chevron
    static var chevronLeft: UIImage? {
        return UIImage(named: "chevronLeft", in: Bundle.module, compatibleWith: .current)
    }
    
    // MARK: - Icon
    static var iconClose: UIImage? {
        return UIImage(named: "iconClose", in: Bundle.module, compatibleWith: .current)
    }
    
    // MARK: - Logo
    static var appLogo: UIImage? {
        return UIImage(named: "appLogo", in: Bundle.module, compatibleWith: .current)
    }
    
    static var logoNamed: UIImage? {
        return UIImage(named: "logoNamed", in: Bundle.module, compatibleWith: .current)
    }
    
    static var patternBase: UIImage? {
        return UIImage(named: "patternBase", in: Bundle.module, compatibleWith: .current)
    }
}
