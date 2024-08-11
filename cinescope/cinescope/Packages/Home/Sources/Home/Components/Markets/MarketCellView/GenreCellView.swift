//
//  GenreCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 9.05.2024.
//

import UIKit
import Components
import AppResources

// MARK: - GenreCellView
final class GenreCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: CustomLabel!
    @IBOutlet private weak var badgeView: UIView!
    @IBOutlet private weak var countLabel: CustomLabel!

    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Publics
extension GenreCellView {
    final func configureWith(
        content: HomeGenreListContent
    ) {
        imageView.image = content.image
        titleLabel.text = content.title
        countLabel.text = content.badge
    }
}

// MARK: - Configuration
private extension GenreCellView {
    final func setupViews() {
        configureContainerView()
        configureTitle()
        configureBadge()
    }

    final func configureContainerView() {
        backgroundColor = .backgroundPrimary
        borderColor = .separator
        borderWidth = 1
        cornerRadius = 14
    }

    final func configureTitle() {
        titleLabel.font = .bold(14)
        titleLabel.textColor = .lightText
    }

    final func configureBadge() {
        badgeView.setCapsuleCornerRadius()
        badgeView.backgroundColor = .systemRed

        countLabel.font = .bold(10)
        countLabel.textColor = .lightText
    }
}
