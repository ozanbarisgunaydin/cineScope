//
//  MovieDescriptionView.swift
//
//
//  Created by Ozan Barış Günaydın on 14.08.2024.
//

import Components
import UIKit

// MARK: - MovieDescriptionView
final class MovieDescriptionView: UIView, NibOwnerLoadable {
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var titleView: MovieSectionTitleView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
    }
}

// MARK: - Publics
extension MovieDescriptionView {
    final func configureWith(
        overview: String?
    ) {
        guard let overview,
              !overview.isEmpty else { return }
        descriptionLabel.text = overview
    }
}

// MARK: - Configuration
private extension MovieDescriptionView {
    final func setupViews() {
        configureContainerView()
        configureLabels()
    }
    
    final func configureContainerView() {
        backgroundColor = .clear
    }
    
    final func configureLabels() {
        titleView.configureWith(title: L10nMovieOverview.title.localized())
        
        descriptionLabel.textColor = .white
        descriptionLabel.font = .medium(14)
        descriptionLabel.text = L10nMovieOverview.emptyDescription.localized()
    }
}
