//
//  BannerCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 28.12.2023.
//

import UIKit
import Components
import AppResources

// MARK: - BannerCellView
final class BannerCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var contentImageView: UIImageView!
    @IBOutlet private weak var titleLabel: CustomLabel!
    
    // MARK: - Data
    private var index: Int?

    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Publics
extension BannerCellView {
    final func configureWith(
        content: BannerContentModel?
    ) {
        setImage(with: content?.imageURL)
        titleLabel.text = content?.title
    }
}

// MARK: - Configuration
private extension BannerCellView {
    final func setupViews() {
        configureImageView()
        configureTitleLabel()
    }
    
    final func configureImageView() {
        contentImageView.contentMode = .scaleAspectFit
        contentImageView.cornerRadius = 20
        contentImageView.borderColor = .white.withAlphaComponent(0.2)
        contentImageView.borderWidth = 2
    }
    
    final func configureTitleLabel() {
        titleLabel.font = .bold(16)
        titleLabel.textColor = .white.withAlphaComponent(0.8)
    }
}

// MARK: - Helpers
private extension BannerCellView {
    final func setImage(with imageUrl: String?) {
        guard let imageUrl else { return }
        contentImageView.loadImage(with: imageUrl)
    }
}
