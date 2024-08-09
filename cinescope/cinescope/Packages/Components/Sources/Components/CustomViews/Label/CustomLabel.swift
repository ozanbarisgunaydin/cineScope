//
//  CustomLabel.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit

// MARK: - CustomLabel
final public class CustomLabel: UILabel {
    // MARK: - Publics
    override public var textColor: UIColor? {
        get {
            return super.textColor
        }
        set {
            super.textColor = newValue
            updateLabel()
        }
    }
    
    override public var textAlignment: NSTextAlignment {
        get {
            return super.textAlignment
        }
        set {
            super.textAlignment = newValue
            updateLabel()
        }
    }
    
    override public var text: String? {
        get {
            return attributedText?.string
        }
        set {
            super.text = newValue
            updateLabel()
        }
    }
    
    override public var font: UIFont? {
        get {
            return super.font
        }
        set {
            super.font = newValue
            updateLabel()
        }
    }
    
    override public var lineBreakMode: NSLineBreakMode {
        get {
            return super.lineBreakMode
        }
        set {
            super.lineBreakMode = newValue
            updateLabel()
        }
    }
    
    // MARK: - @IBInspectable
    @IBInspectable var lineHeight: CGFloat = 0.0 {
        didSet {
            updateLabel()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textColor = .pearlBlack
    }
}

// MARK: - Publics
public extension CustomLabel {
    final func setAttrbutedText(
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

// MARK: - Privates
private extension CustomLabel {
    final func updateLabel() {
        guard let text else { return }
        var attributes = attributedText?.attributes
        
        attributes?.updateValue(
            font ?? .systemFont(ofSize: 12),
            forKey: NSAttributedString.Key.font
        )
        attributes?.updateValue(
            textColor ?? .black,
            forKey: NSAttributedString.Key.foregroundColor
        )
        let attributeString = NSMutableAttributedString(
            string: text,
            attributes: attributes
        )
        
        let style = NSMutableParagraphStyle()
        style.alignment = textAlignment
        style.lineBreakMode = lineBreakMode
        
        var height: CGFloat = lineHeight
        if height == 0 {
            height = font?.lineHeight ?? 0.0
        }
        style.maximumLineHeight = height
        style.minimumLineHeight = height
        
        attributeString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributeString.length)
        )
        
        attributedText = attributeString
    }
}
