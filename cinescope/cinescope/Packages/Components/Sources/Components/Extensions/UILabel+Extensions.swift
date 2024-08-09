//
//  UILabel+Extensions.swift
//  
//
//  Created by Ufuk Canlı on 13.03.2024.
//

import UIKit

// MARK: - Publics
public extension UILabel {
    final func setAttributedText(
        fullText: String,
        attributedPart: String,
        attributedFont: UIFont,
        normalFont: UIFont,
        textColor: UIColor
    ) {
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                NSAttributedString.Key.font: normalFont,
                NSAttributedString.Key.foregroundColor: textColor
            ]
        )

        let range = (fullText as NSString).range(of: attributedPart)

        attributedString.addAttribute(
            NSAttributedString.Key.font,
            value: attributedFont,
            range: range
        )

        attributedText = attributedString
    }
}
