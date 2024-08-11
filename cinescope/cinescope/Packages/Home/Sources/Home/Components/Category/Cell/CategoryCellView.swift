//
//  CategoryCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 9.05.2024.
//

import UIKit
import Components

// MARK: - CategoryCellView
final class CategoryCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: CustomLabel!
    
    // MARK: - Constants
    static let widthToHeightRatio: CGFloat = 128 / 378

    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Publics
extension CategoryCellView {
    final func configureWith(
        type: CategoryType
    ) {
        imageView.image = type.coverImage
        titleLabel.text = type.title
    }
}

// MARK: - Configuration
private extension CategoryCellView {
    final func setupViews() {
        configureContainerView()
        configureImageView()
        configureTitleLabel()
    }

    final func configureContainerView() {
        backgroundColor = .clear
        borderColor = .separator
        borderWidth = 1
        cornerRadius = 16
    }

    final func configureImageView() {
        imageView.contentMode = .scaleAspectFit
    }
    
    final func configureTitleLabel() {
        titleLabel.font = .bold(13)
        titleLabel.textColor = .white
    }
}
