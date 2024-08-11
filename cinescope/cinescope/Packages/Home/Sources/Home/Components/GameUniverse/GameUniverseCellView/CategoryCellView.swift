//
//  CategoryCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 9.05.2024.
//

import UIKit
import Components

// MARK: - CategoryCellView
final public class CategoryCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var imageView: UIImageView!

    // MARK: - Constants
    static let widthToHeightRatio: CGFloat = 0.38

    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Publics
public extension CategoryCellView {
    final func configureWith(
        image: UIImage?
    ) {
        imageView.image = image
    }
}

// MARK: - Configuration
private extension CategoryCellView {
    final func setupViews() {
        configureContainerView()
    }

    final func configureContainerView() {
        backgroundColor = .clear
    }

    final func configureImageView() {
        imageView.cornerRadius = 14
    }
}
