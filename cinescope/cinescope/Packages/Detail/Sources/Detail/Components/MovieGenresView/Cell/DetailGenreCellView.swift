//
//  DetailGenreCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 14.08.2024.
//

import UIKit
import Components

// MARK: - DetailGenreCellView
final class DetailGenreCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    
    // MARK: - Constant
    static let cellHeight: CGFloat = 32

    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
}

// MARK: - Publics
extension DetailGenreCellView {
    final func configureWith(
        genreTitle: String
    ) {
        typeLabel.text = genreTitle
    }
}

// MARK: - Configuration
private extension DetailGenreCellView {
    final func setupViews() {
        configureContainerView()
        configureLabel()
    }
    
    final func configureContainerView() {
        backgroundColor = .primaryColor.withAlphaComponent(0.4)
        
        gradientView.setGradientBackground(
            colors: [
                .white.withAlphaComponent(0.1),
                .white.withAlphaComponent(0.2),
                .white.withAlphaComponent(0.1)
            ],
            locations: [0, 0.5, 1]
        )
        
        borderColor = .separator
        borderWidth = 2
        cornerRadius = 8
    }
    
    final func configureLabel() {
        typeLabel.textColor = .white
        typeLabel.font = .bold(12)
    }
}
