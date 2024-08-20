//
//  FavoriteMovieCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 20.08.2024.
//

import AppManagers
import Components
import UIKit

// MARK: - FavoriteMovieCellView
final class FavoriteMovieCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var backdropImageView: UIImageView!
    @IBOutlet private weak var imageOverlayView: UIView!
    @IBOutlet private weak var imageContainerView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var voteLabel: UILabel!
    
    // MARK: - Constant
    private let cellHeight: CGFloat = 144
    
    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Publics
extension FavoriteMovieCellView {
    final func configureWith(
        content: FavoriteCellContent
    ) {
        backdropImageView.loadImage(with: content.backdropImageURL)
        titleLabel.text = content.title
        dateLabel.text = content.date
        voteLabel.text = content.vote
    }
}

// MARK: - Configuration
private extension FavoriteMovieCellView {
    final func setupViews() {
        configureContainerView()
        configureImageViews()
        configureTitleLabels()
    }
    
    final func configureContainerView() {
        heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
        backgroundColor = .clear
    }
    
    final func configureImageViews() {
        imageContainerView.setCapsuleCornerRadius()
        imageContainerView.borderColor = .separator
        imageContainerView.borderWidth = 2
        
        imageOverlayView.backgroundColor = .clear
        imageOverlayView.setGradientBackground(
            colors: [
                .black,
                .black.withAlphaComponent(0.2)
            ],
            locations: [0.25, 0.5],
            startPoint: CGPoint(x: 0.0, y: 0.5),
            endPoint: CGPoint(x: 1.0, y: 0.5)
        )
        
        backdropImageView.contentMode = .scaleAspectFit
    }
    
    final func configureTitleLabels() {
        titleLabel.font = .bold(18)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        
        dateLabel.font = .medium(14)
        dateLabel.textColor = .white.withAlphaComponent(0.9)
        
        voteLabel.font = .bold(14)
        voteLabel.textColor = .systemYellow
    }
}
