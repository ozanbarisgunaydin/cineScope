//
//  PersonCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 9.05.2024.
//

import UIKit
import Components
import AppResources

// MARK: - PersonCellView
final class PersonCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var personImageView: UIImageView!
    @IBOutlet private weak var nameContainerView: UIView!
    @IBOutlet private weak var nameLabel: CustomLabel!
    @IBOutlet private weak var topMoviePoster: UIImageView!
    @IBOutlet private weak var middleMoviePoster: UIImageView!
    @IBOutlet private weak var bottomMoviePoster: UIImageView!

    // MARK: - Constants
    static let viewSize = CGSize(width: 210, height: 169)

    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Publics
extension PersonCellView {
    final func configureWith(
        content: PersonContent
    ) {
        personImageView.loadImage(with: content.profileImageURL)
        nameLabel.text = content.artistName
        topMoviePoster.loadImage(with: content.knownedMoviePosters[safe: 0] ?? "")
        middleMoviePoster.loadImage(with: content.knownedMoviePosters[safe: 1] ?? "")
        bottomMoviePoster.loadImage(with: content.knownedMoviePosters[safe: 2] ?? "")
    }
}

// MARK: - Configuration
private extension PersonCellView {
    final func setupViews() {
        configureContainerView()
        configureNameViews()
    }

    final func configureContainerView() {
        backgroundColor = .backgroundPrimary
        borderColor = .separator
        borderWidth = 1
        cornerRadius = 14
    }
    
    final func configureNameViews() {
        nameLabel.textAlignment = .center
        nameLabel.font = .bold(12)
        nameLabel.textColor = .white.withAlphaComponent(0.8)
        nameLabel.numberOfLines = 0
        
        nameContainerView.backgroundColor = .black.withAlphaComponent(0.7)
    }
   
}
