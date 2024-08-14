//
//  MovieSectionTitleView.swift
//
//
//  Created by Ozan Barış Günaydın on 14.08.2024.
//

import Components
import UIKit

// MARK: - MovieSectionTitleView
final class MovieSectionTitleView: UIView, NibOwnerLoadable {
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
    }
}

// MARK: - Publics
extension MovieSectionTitleView {
    final func configureWith(
        isSeparatorHidden: Bool = false,
        title: String
    ) {
        separatorView.isHidden = isSeparatorHidden
        titleLabel.text = title
    }
}

// MARK: - Configuration
private extension MovieSectionTitleView {
    final func setupViews() {
        configureContainerView()
        configureSeparatorView()
        configureTitleLabel()
    }
    
    final func configureContainerView() {
        backgroundColor = .clear
    }
    
    final func configureSeparatorView() {
        separatorView.backgroundColor = .separator
    }
    
    final func configureTitleLabel() {
        titleLabel.textColor = .white
        titleLabel.font = .bold(18)
    }
}
