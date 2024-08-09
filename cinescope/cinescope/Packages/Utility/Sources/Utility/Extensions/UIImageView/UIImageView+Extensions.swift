//
//  UIImageView+Extensions.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit.UIImageView

public extension UIImageView {
    func setTintColor(_ color: UIColor) {
        guard let originalImage = self.image else {
            return
        }
        
        self.image = originalImage.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
