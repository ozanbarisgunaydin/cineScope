//
//  Button.swift
//  
//
//  Created by Ozan Barış Günaydın on 14.12.2023.
//

import Utility
import UIKit

// MARK: - ButtonStyle
public enum ButtonStyle {
    case primary
    case secondary
    case bordered
    case plain
    case destructive
}

// MARK: - Button
public class Button: UIButton {
    // MARK: - UI Components
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    // MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = 10
    }

    // MARK: - Publics
    public var title: String? {
        didSet {
            guard let title else { return }
            setTitleForAllStates(title)
        }
    }

    public var buttonStyle: ButtonStyle = .primary {
        didSet {
            configureApperanceForButtonStyle()
        }
    }

    public var disabledBackgroundColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }

    public var normalBackgroundColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }

    public var imageTintColor: UIColor = .white {
        didSet {
            updateBackgroundColor()
        }
    }

    public func setTrailingImageConstraint(trailingPadding: CGFloat = 18) {
        addSubview(iconImageView)
        NSLayoutConstraint.activate(
            [
                iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailingPadding)
            ]
        )

        if let titleLabel {
            iconImageView.leadingAnchor.constraint(
                greaterThanOrEqualTo: titleLabel.leadingAnchor,
                constant: -4
            ).isActive = true
        }
    }

    public func setTrailingImage(
        with image: UIImage?,
        size: CGSize = CGSize(width: 20, height: 20),
        tintColor: UIColor? = nil
    ) {
        guard let image else { return }
        var resizedImage = image.resized(to: size)
        if let tintColor {
            resizedImage = resizedImage.withTintColor(tintColor)
        }
        iconImageView.image = resizedImage
    }

    // MARK: - Override
    public override var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureApperanceForButtonStyle()
        setNeedsDisplay()
    }
}

// MARK: - Privates
private extension Button {
    final func commonInit() {
        titleLabel?.font = .medium(14)
        buttonStyle = .primary
        configureApperanceForButtonStyle()

        guard #available(iOS 15.0, *) else { return }
        configuration = nil
    }

    final func setDefaultDisabledProperties() {
        setBackgroundColor(
            .primaryColor.withAlphaComponent(0.2),
            for: .disabled
        )
        setTitleColor(
            .primaryColor.withAlphaComponent(0.4),
            for: .disabled
        )
    }

    final func clearBorder() {
        borderWidth = 0
        borderColor = .clear
    }

    final func configureApperanceForButtonStyle() {
        setDefaultDisabledProperties()
        clearBorder()

        switch buttonStyle {
        case .primary:
            setTitleColor(.white, for: .normal)
            setBackgroundColor(
                .primaryColor,
                for: .normal
            )
        case .secondary:
            setTitleColor(
                .primaryColor,
                for: .normal
            )
            setBackgroundColor(
                .primaryColor.withAlphaComponent(0.1),
                for: .normal
            )
        case .bordered:
            setTitleColor(
                .pearlBlack,
                for: .normal
            )
            setBackgroundColor(
                .lightGray,
                for: .normal
            )

            setBackgroundColor(
                .darkGray,
                for: .disabled
            )
            setTitleColor(
                .black.withAlphaComponent(0.4),
                for: .disabled
            )

            borderWidth = 1
            borderColor = .separator
        case .plain:
            setTitleColor(
                .primaryColor,
                for: .normal
            )
            setBackgroundColor(
                .clear,
                for: .normal
            )
        case .destructive:
            setTitleColor(
                .mandyRed,
                for: .normal
            )
            setBackgroundColor(
                .backgroundRed,
                for: .normal
            )
        }
    }

    final func setBackgroundColor(
        _ color: UIColor?,
        for state: UIControl.State
    ) {
        switch state {
        case .normal:
            normalBackgroundColor = color
        case .disabled:
            disabledBackgroundColor = color
        default:
            break
        }
    }

    final func updateBackgroundColor() {
        if isEnabled {
            backgroundColor = normalBackgroundColor
            iconImageView.setTintColor(imageTintColor)
        } else {
            backgroundColor = disabledBackgroundColor
        }
    }
}
