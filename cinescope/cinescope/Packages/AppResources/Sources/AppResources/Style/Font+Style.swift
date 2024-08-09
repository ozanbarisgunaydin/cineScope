//
//  Font+Style.swift
//  
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Foundation
import UIKit

extension UIFont {
    public class func bold(_ size: CGFloat) -> UIFont {
        return font(size: size, weight: .bold)
    }

    public class func boldItalic(_ size: CGFloat) -> UIFont {
        return font(size: size, weight: .boldItalic)
    }

    public class func italic(_ size: CGFloat) -> UIFont {
        return font(size: size, weight: .italic)
    }

    public class func light(_ size: CGFloat) -> UIFont {
        return font(size: size, weight: .light)
    }

    public class func lightItalic(_ size: CGFloat) -> UIFont {
        return font(size: size, weight: .lightItalic)
    }

    public class func medium(_ size: CGFloat) -> UIFont {
        return font(size: size, weight: .medium)
    }

    public class func mediumItalic(_ size: CGFloat) -> UIFont {
        return font(size: size, weight: .mediumItalic)
    }

    public class func regular(_ size: CGFloat) -> UIFont {
        return font(size: size, weight: .regular)
    }
}
