//
//  UIView+Customize.swift
//
//
//  Created by Ozan Barış Günaydın on 14.08.2024.
//

import UIKit.UIView

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

// MARK: - Blur Effect
public extension UIView {
    /// Adds blue overlay to view
    /// - Parameter effectStyle: UIBlurEffect's style type
    final func addBlurOverlay(with effectStyle: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: effectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
