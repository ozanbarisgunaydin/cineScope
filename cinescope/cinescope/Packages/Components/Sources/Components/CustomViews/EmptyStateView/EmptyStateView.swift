//
//  EmptyStateView.swift
//
//
//  Created by Ozan Barış Günaydın on 13.01.2024.
//

import AppResources
import Utility
import UIKit

// MARK: - EmptyStateView
final public class EmptyStateView: UIView, NibOwnerLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!

    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
    }
}

// MARK: - Publics
public extension EmptyStateView {
    final func configureWith(
        icon: UIImage? = .circleInfo,
        title: String? = L10nEmptyState.title.localized(),
        message: String? = L10nEmptyState.message.localized()
    ) {
        imageView.image = icon

        titleLabel.text = title
        titleLabel.isHidden = title == nil

        messageLabel.text = message
        messageLabel.isHidden = message == nil
    }
}

// MARK: - Configuration
private extension EmptyStateView {
    final func setupViews() {
        configureContainerView()
        configureLabels()
    }

    final func configureContainerView() {
        backgroundColor = .clear
    }

    final func configureLabels() {
        titleLabel.textColor = .white
        titleLabel.font = .bold(16)

        messageLabel.textColor = .white.withAlphaComponent(0.8)
        messageLabel.font = .regular(14)
    }
}
