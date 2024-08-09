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
final public class BannerCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var contentImageView: UIImageView!

    // MARK: - Data
    private var index: Int?

    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Publics
public extension BannerCellView {
    final func configureWith(
        imageUrlString: String?
    ) {
        setImage(with: imageUrlString)
    }
}

// MARK: - Configuration
private extension BannerCellView {
    final func setupViews() {
        configureImageView()
    }
    
    final func configureImageView() {
        contentImageView.contentMode = .scaleAspectFit
        contentImageView.cornerRadius = 20
    }
}

// MARK: - Helpers
private extension BannerCellView {
    final func setImage(with imageUrl: String?) {
        guard let imageUrl else { return }
        contentImageView.loadImage(with: imageUrl)
    }
}
