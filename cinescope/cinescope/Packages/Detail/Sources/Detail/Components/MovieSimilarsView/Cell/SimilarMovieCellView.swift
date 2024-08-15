//
//  SimilarMovieCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 15.08.2024.
//

import UIKit
import Components

// MARK: - SimilarMovieCellView
final class SimilarMovieCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleBackgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Constant
    static let cellSize = CGSize(width: 100, height: 150)
    
    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
}

// MARK: - Publics
extension SimilarMovieCellView {
    final func configureWith(
        imageURL: String?,
        title: String?
    ) {
        posterImageView.loadImage(with: imageURL)
        titleLabel.text = title
    }
}

// MARK: - Configuration
private extension SimilarMovieCellView {
    final func setupViews() {
        configureContainerView()
        configureLabel()
        configureTitleBackgroundView()
    }
    
    final func configureContainerView() {
        backgroundColor = .primaryColor.withAlphaComponent(0.4)
        borderColor = .separator
        borderWidth = 2
        cornerRadius = 8
    }
    
    final func configureLabel() {
        titleLabel.font = .bold(12)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
    }
    
    final func configureTitleBackgroundView() {
        titleBackgroundView.backgroundColor = .black.withAlphaComponent(0.4)
    }
}

