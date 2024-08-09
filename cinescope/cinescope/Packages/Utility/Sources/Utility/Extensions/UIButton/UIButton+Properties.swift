//
//  UIButton+Properties.swift
//
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit.UIButton

public extension UIButton {
    private var states: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
    
    func setImageForAllStates(_ image: UIImage?) {
        states.forEach { setImage(image, for: $0) }
    }
    
    func setTitleColorForAllStates(_ color: UIColor) {
        states.forEach { setTitleColor(color, for: $0) }
    }
    
    func setTitleForAllStates(_ title: String) {
        states.forEach { setTitle(title, for: $0) }
    }
    
    func setAttributedTitleForAllStates(
        text: String,
        font: UIFont,
        titleColor: UIColor
    ) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: titleColor
        ]
        
        states.forEach { state in
            setAttributedTitle(
                NSMutableAttributedString(
                    string: text,
                    attributes: attributes
                ),
                for: state
            )
        }
    }
    
    func centerTextAndImage(
        imageAboveText: Bool = false,
        spacing: CGFloat
    ) {
        if imageAboveText,
           let text = titleLabel?.text,
           let font = titleLabel?.font {
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = currentImage
            
            let imageString = NSAttributedString(attachment: imageAttachment)
            
            let textString = NSAttributedString(
                string: "\n\(text)",
                attributes: [.font: font]
            )
            
            let combinedString = NSMutableAttributedString()
            combinedString.append(imageString)
            combinedString.append(textString)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            combinedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: combinedString.length))
            
            setAttributedTitle(combinedString, for: .normal)
            titleLabel?.numberOfLines = 0
            titleLabel?.textAlignment = .center
            
            let halfSpacing = spacing / 2
            let buttonConfiguration = UIButton.Configuration.plain()
            var container = AttributeContainer()
            container.font = font
            
            configuration = buttonConfiguration
            configuration?.contentInsets = NSDirectionalEdgeInsets(top: halfSpacing, leading: 0, bottom: halfSpacing, trailing: 0)
        } else {
            let halfSpacing = spacing / 2
            let buttonConfiguration = UIButton.Configuration.plain()
            configuration = buttonConfiguration
            configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: halfSpacing, bottom: 0, trailing: halfSpacing)
        }
    }
}
