//
//  NSAttributedString+Extensions.swift
//  
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import Foundation

public extension NSAttributedString {
    var attributes: [Key: Any] {
        guard length > 0 else { return [:] }
        return attributes(at: 0, effectiveRange: nil)
    }
}
