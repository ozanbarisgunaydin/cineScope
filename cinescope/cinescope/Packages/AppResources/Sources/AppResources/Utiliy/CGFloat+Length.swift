//
//  CGFloat+Length.swift
//
//
//  Created by Ozan Barış Günaydın on 9.08.2024.
//

import UIKit.UIScreen

public extension CGFloat {
    // MARK: - Spacing
    /// 0
    static let spacingZero: CGFloat = 0
    /// 4
    static let spacingSmall: CGFloat = 4
    /// 8
    static let spacingMedium: CGFloat = 8
    /// 12
    static let spacingLarge: CGFloat = 12
    
    // MARK: - Padding
    /// 16
    static let paddingMedium: CGFloat = 16
    /// 24
    static let paddingLarge: CGFloat = 24
    
    // MARK: - Length
    /// UIScreen.main.bounds.width
    static let lengthScreenWidth: CGFloat = UIScreen.main.bounds.width
}
