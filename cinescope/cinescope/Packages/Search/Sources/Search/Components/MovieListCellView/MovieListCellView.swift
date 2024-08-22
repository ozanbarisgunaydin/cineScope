//
//  MovieListCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 16.08.2024.
//

import Components
import UIKit

// MARK: - MovieListCellView
final class MovieListCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var overlayImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var voteLabel: UILabel!
    
    // MARK: - Constant
    static let widthToHeightRatio: CGFloat = 75 / 50
    
    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Publics
extension MovieListCellView {
    final func configureWith(
        content: MovieListCellContent
    ) {
        titleLabel.text = content.title
        posterImageView.loadImage(
            with: content.posterURL,
            placeholderImage: .placeholderPoster
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                overlayImageView.isHidden = false
            case .failure:
                overlayImageView.isHidden = true
            }
        }
        yearLabel.text = content.year
        voteLabel.text = content.vote
    }
}

// MARK: - Configuration
private extension MovieListCellView {
    final func setupViews() {
        configureContainerView()
        configureImageViews()
        configureLabels()
    }
    
    final func configureContainerView() {
        borderColor = .white.withAlphaComponent(0.8)
        borderWidth = 1
        cornerRadius = 4
    }
    
    final func configureImageViews() {
        posterImageView.contentMode = .scaleAspectFit
        overlayImageView.image = .cellOverlay
    }
    
    final func configureLabels() {
        titleLabel.font = .bold(14)
        titleLabel.numberOfLines = 0

        yearLabel.font = .medium(12)
        yearLabel.textColor = .lightText
        
        voteLabel.font = .bold(10)
        voteLabel.textColor = .systemYellow
    }
}
