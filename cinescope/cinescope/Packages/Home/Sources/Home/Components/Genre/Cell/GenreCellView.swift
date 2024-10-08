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
    @IBOutlet private weak var gradientView: UIView!
    
    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Publics
extension GenreCellView {
    final func configureWith(
        content: GenreType
    ) {
        imageView.image = content.image
        titleLabel.text = content.rawValue
    }
}

// MARK: - Configuration
private extension GenreCellView {
    final func setupViews() {
        configureContainerView()
        configureTitle()
    }

    final func configureContainerView() {
        backgroundColor = .backgroundPrimary
        
        gradientView.setGradientBackground(
            colors: [
                .white.withAlphaComponent(0.1),
                .white.withAlphaComponent(0.2),
                .white.withAlphaComponent(0.1)
            ],
            locations: [0, 0.5, 1]
        )
        
        
        borderColor = .separator
        borderWidth = 1
        cornerRadius = 14
    }

    final func configureTitle() {
        titleLabel.font = .bold(14)
        titleLabel.textColor = .white
    }
}
