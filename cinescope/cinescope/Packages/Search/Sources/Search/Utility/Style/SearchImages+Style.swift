//
//  SearchImages+Style.swift
//
//
//  Created by Ozan Barış Günaydın on 16.08.2024.
//

import UIKit.UIImage

public extension UIImage {
    // MARK: - Circle Icon
    static var cellOverlay: UIImage? {
        return UIImage(named: "cellOverlay", in: Bundle.module, compatibleWith: .current)
    }
}
