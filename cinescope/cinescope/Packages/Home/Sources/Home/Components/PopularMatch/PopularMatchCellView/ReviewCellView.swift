//
//  ReviewCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 9.05.2024.
//

import UIKit
import Components
import AppResources

// MARK: - ReviewCellView
final class ReviewCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var contentImageView: UIImageView!

    // MARK: - Constants
    static let viewSize = CGSize(width: 235, height: 95)

    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Publics
extension ReviewCellView {
    final func configureWith(
        content: MovieReview
    ) {
        
    }
}

// MARK: - Configuration
private extension ReviewCellView {
    final func setupViews() {
        configureContainerView()
    }

    final func configureContainerView() {
        backgroundColor = .backgroundPrimary
        borderColor = .separator
        borderWidth = 1
        cornerRadius = 14
    }
   
}
