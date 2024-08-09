//
//  UIImage+Extensions.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit.UIImage

public extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        draw(in: CGRect(origin: .zero, size: size))
        
        if let resizedImage = UIGraphicsGetImageFromCurrentImageContext() {
            return resizedImage
        }
        
        return self
    }
}
