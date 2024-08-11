//
//  Color+Style.swift
//
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Foundation
import UIKit

public extension UIColor {
    // MARK: - Theme
    /// #690000
    static var primaryColor: UIColor {
        return UIColor(named: "primaryColor", in: Bundle.module, compatibleWith: .current) ?? UIColor.white
    }
    
    // MARK: - Black
    /// #091934
    static var pearlBlack: UIColor {
        return UIColor(named: "pearlBlack", in: Bundle.module, compatibleWith: .current) ?? UIColor.black
    }
    
    // MARK: - Red
    /// #E04C4C
    static var mandyRed: UIColor {
        return UIColor(named: "mandyRed", in: Bundle.module, compatibleWith: .current) ?? UIColor.red
    }
    
    // MARK: - Background
    /// #1F222A
    static var backgroundNavBar: UIColor {
        return UIColor(named: "backgroundNavBar", in: Bundle.module, compatibleWith: .current) ?? UIColor.white
    }
    /// #1F222A
    static var backgroundPrimary: UIColor {
        return UIColor(named: "backgroundPrimary", in: Bundle.module, compatibleWith: .current) ?? UIColor.white
    }
    /// #FEEFF0
    static var backgroundRed: UIColor {
        return UIColor(named: "backgroundRed", in: Bundle.module, compatibleWith: .current) ?? UIColor.white
    }
}
