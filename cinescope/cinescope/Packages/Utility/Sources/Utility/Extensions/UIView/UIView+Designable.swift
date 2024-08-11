//
//  UIView+Designable.swift
//  OBG
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import UIKit.UIView

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerCurve = .continuous
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var layerShadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var layerShadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var layerShadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var layerShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    func setCapsuleCornerRadius() {
        self.cornerRadius = self.height / 2
    }
}

// MARK: - Gradient
public extension UIView {
    /// Sets a gradient background for the UIView.
    ///
    /// - Parameters:
    ///   - colors: An array of UIColor objects representing the gradient colors.
    ///   - locations: An array of Double values representing the gradient locations.
    ///
    /// Example usage:
    /// ```
    /// let gradientButton = UIButton(type: .system)
    /// gradientButton.setGradientBackground(colors: [.red, .blue], locations: [0.0, 1.0])
    /// ```
    ///
    /// P.S. It should be used in the `layoutSubviews()` method of the cell's own view for proper implementation.
    func setGradientBackground(
        colors: [UIColor],
        locations: [Double],
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)
    )  {
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "gg"
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations.map { NSNumber(value: $0) }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func removeGradientBackground() {
        layer.sublayers?.removeAll(where: { $0.name == "gg" })
    }
    
    /// Update the gradient colors for the UIView.
    ///
    /// - Parameter newColors: An array of UIColor objects representing the new gradient colors.
    func updateGradientColors(newColors: [UIColor]) {
        if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.colors = newColors.map { $0.cgColor }
        }
    }
}
