//
//  BaseNibOwnerView.swift
//
//
//  Created by Ozan Barış Günaydın on 14.12.2023.
//

import UIKit

// MARK: - BaseNibOwnerView
public class BaseNibOwnerView: UIView, NibOwnerLoadable {
    // MARK: - NibOwnerLoadable
    public static var module = Bundle.module

    // MARK: - Public Variables
    var isSelectable = false

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        commonInit()
    }

    // MARK: - Setup
    private func commonInit() {
        setupViews()
        setupLayout()
    }

    open func setupViews() {
        backgroundColor = .clear
        clipsToBounds = false
        layer.masksToBounds = false
    }

    open func setupLayout() {
    }

    // MARK: - Selection Animations
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard isSelectable else { return }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard isSelectable else { return }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        guard isSelectable else { return }
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}
