//
//  StackedPageControl.swift
//
//
//  Created by Ozan Barış Günaydın on 28.12.2023.
//

import AppResources
import UIKit
import Utility

// MARK: - StackedPageControl
final public class StackedPageControl: UIView {
    // MARK: - Private Properties
    private var currentPageColor: UIColor?
    private var otherPageColor: UIColor?
    private var dotSpacing: CGFloat?
    private var alignment: UIRectEdge = .left
    private let dotHeight: CGFloat = 4

    private var stackView = UIStackView()
    private var oldCurentPageIndex: Int = 0

    // MARK: - Public Variables
    public var currentPage: Int = 0 {
        didSet {
            guard !self.isHidden else { return }
            reloadView()
        }
    }

    public var numberOfPages: Int = 0 {
        didSet {
            if numberOfPages == 1 {
                self.isHidden = true
            } else {
                self.isHidden = false
                reloadView()
            }
        }
    }

    final func configureWith(
        currentPageColor: UIColor? = .primaryColor,
        otherPageColor: UIColor? = .clear,
        spacing: CGFloat = 4,
        alignment: UIRectEdge = .left,
        backgroundColor: UIColor = .white.withAlphaComponent(0.2)
    ) {
        self.currentPageColor = currentPageColor
        self.otherPageColor = otherPageColor
        self.dotSpacing = spacing
        self.alignment = alignment
        stackView.backgroundColor = backgroundColor

        setupView()
    }
}

// MARK: - Private Methods
private extension StackedPageControl {
    /// Remove all subviews and clear the stackView componet and reload view again. Works only the stack view contains some subviews for prevents crashs.
    final func reloadView() {
        guard !subviews.isEmpty else { return }
        stackView.removeAllArrangedSubviews()
        setupView()
    }

    /// Sets the constraint of the stack view and detects the selected alignment type of view. If some edge selected than removes the across constraint for providing desired alignment.
    final func setConstraints() {
        var constraintsArray: [NSLayoutConstraint] = [
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        stackView.setCapsuleCornerRadius()

        switch alignment {
        case .left:
            constraintsArray.remove(at: 1)
        case .right:
            constraintsArray.remove(at: 0)
        case .top:
            constraintsArray.remove(at: 3)
        case .bottom:
            constraintsArray.remove(at: 2)
        case .all:
            constraintsArray.removeSubrange(0...1)
            constraintsArray.append(stackView.centerXAnchor.constraint(equalTo: centerXAnchor))
        default:
            break
        }

        NSLayoutConstraint.activate(constraintsArray)
    }

    /// Configures the stack view's properties
    final func configureStackView() {
        guard let dotSpacing else { return }

        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = dotSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        setConstraints()
    }

    /// Setup the main stack view if the needed images and sizes existed.
    final func setupView() {
        guard let currentPageColor,
              let otherPageColor else { return }

        configureStackView()

        for index in 0..<numberOfPages {
            let isCurrentPage = index == currentPage

            let dot = UIView()
            dot.backgroundColor = isCurrentPage ? currentPageColor : otherPageColor
            dot.cornerRadius = dotHeight / 2

            dot.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dot.widthAnchor.constraint(equalToConstant: .spacingLarge),
                dot.heightAnchor.constraint(equalToConstant: dotHeight)
            ])

            stackView.addArrangedSubview(dot)
        }
    }
}
