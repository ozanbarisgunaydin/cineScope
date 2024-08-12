//
//  Image+Style.swift
//
//
//  Created by Ozan Barış Günaydın on 18.12.2023.
//

import UIKit

public extension UIImage {
    
    static var homeTabSelected: UIImage? {
        return UIImage(named: "homeTabSelected", in: Bundle.module, compatibleWith: .current)
    }
    static var homeTabUnselected: UIImage? {
        return UIImage(named: "homeTabUnselected", in: Bundle.module, compatibleWith: .current)
    }
    
    static var searchTabSelected: UIImage? {
        return UIImage(named: "searchTabSelected", in: Bundle.module, compatibleWith: .current)
    }
    
    static var searchTabUnselected: UIImage? {
        return UIImage(named: "searchTabUnselected", in: Bundle.module, compatibleWith: .current)
    }

    static var favoritesTabSelected: UIImage? {
        return UIImage(named: "favoritesTabSelected", in: Bundle.module, compatibleWith: .current)
    }

    static var favoritesTabUnselected: UIImage? {
        return UIImage(named: "favoritesTabUnselected", in: Bundle.module, compatibleWith: .current)
    }
}
