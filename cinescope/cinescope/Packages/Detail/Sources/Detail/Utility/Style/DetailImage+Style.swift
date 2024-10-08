//
//  DetailImage+Style.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import Foundation

import UIKit.UIImage

public extension UIImage {
    static var revenue: UIImage? {
        return UIImage(named: "revenue", in: Bundle.module, compatibleWith: .current)
    }
    
    static var budget: UIImage? {
        return UIImage(named: "budget", in: Bundle.module, compatibleWith: .current)
    }
    
    static var star: UIImage? {
        return UIImage(named: "star", in: Bundle.module, compatibleWith: .current)
    }
    
    static var imdbLogo: UIImage? {
        return UIImage(named: "imdbLogo", in: Bundle.module, compatibleWith: .current)
    }
    
    static var hyperlink: UIImage? {
        return UIImage(named: "hyperlink", in: Bundle.module, compatibleWith: .current)
    }
    
    static var placholderCompany: UIImage? {
        return UIImage(named: "placholderCompany", in: Bundle.module, compatibleWith: .current)
    }
}
