//
//  SearchKeywordCellView.swift
//
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import Components
import UIKit

// MARK: - SearchKeywordCellView
final class SearchKeywordCellView: UICollectionViewCell, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var keywordLabel: UILabel!
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
extension SearchKeywordCellView {
    final func configureWith(
        keyword: String
    ) {
        keywordLabel.text = keyword
    }
}

// MARK: - Configuration
private extension SearchKeywordCellView {
    final func setupViews() {
        configureContainerView()
        configureLabel()
    }
    
    final func configureContainerView() {
        backgroundColor = .darkGray.withAlphaComponent(0.4)
        
        gradientView.setGradientBackground(
            colors: [
                .white.withAlphaComponent(0.1),
                .backgroundRed.withAlphaComponent(0.2),
                .white.withAlphaComponent(0.1)
            ],
            locations: [0, 0.5, 1]
        )
        
        borderColor = .separator
        borderWidth = 2
        cornerRadius = 8
    }
    
    final func configureLabel() {
        keywordLabel.textColor = .white.withAlphaComponent(0.8)
        keywordLabel.font = .mediumItalic(14)
    }
}

