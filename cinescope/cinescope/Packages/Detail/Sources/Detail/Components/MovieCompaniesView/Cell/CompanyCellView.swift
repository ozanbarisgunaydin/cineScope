//
//  CompanyCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 16.08.2024.
//

import UIKit
import Components

// MARK: - CompanyCellView
final class CompanyCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var logoContainerView: UIView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    // MARK: - Constant
    static let cellHeight: CGFloat = 70
    
    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
}

// MARK: - Publics
extension CompanyCellView {
    final func configureWith(
        name: String?,
        imageURL: String?
    ) {
        nameLabel.text = name
        logoImageView.loadImage(
            with: imageURL,
            placeholderImage: .placholderCompany
        )
    }
}

// MARK: - Configuration
private extension CompanyCellView {
    final func setupViews() {
        configureContainerView()
        configureImageViews()
        configureLabel()
    }
    
    final func configureContainerView() {
        backgroundColor = .backgroundPrimary.withAlphaComponent(0.8)
        borderColor = .separator
        borderWidth = 2
        cornerRadius = 8
    }
    
    final func configureImageViews() {
        logoContainerView.backgroundColor = .white.withAlphaComponent(0.8)
        logoImageView.contentMode = .scaleAspectFit
    }
    
    final func configureLabel() {
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.font = .bold(12)
    }
}
