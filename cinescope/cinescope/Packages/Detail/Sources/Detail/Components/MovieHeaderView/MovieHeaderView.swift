//
//  MovieHeaderView.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import AppResources
import Components
import UIKit

// MARK: - MovieHeaderView
final class MovieHeaderView: UIView, NibOwnerLoadable {
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var posterHeight: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var detailStack: UIStackView!
    @IBOutlet private weak var originalTitleLabel: UILabel!
    
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var voteView: VoteView!
    
    @IBOutlet private weak var budgetImageView: UIImageView!
    @IBOutlet private weak var budgetTitleLabel: UILabel!
    @IBOutlet private weak var budgetLabel: UILabel!
    @IBOutlet private weak var revenueImageView: UIImageView!
    @IBOutlet private weak var revenueTitleLabel: UILabel!
    @IBOutlet private weak var revenueLabel: UILabel!
    
    // MARK: - Data
    private var isAnimationCompleted = true
    
    // MARK: - Constants
    static let expendedHeight: CGFloat = 250
    static let collapsedHeight: CGFloat = 80

    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
    }
}

// MARK: - Publics
extension MovieHeaderView {
    final func configureWith(
        content: MovieHeaderContent
    ) {
        titleLabel.text = content.title
        originalTitleLabel.text = content.originalTitle
        originalTitleLabel.isHidden = content.title == content.originalTitle
        posterImageView.loadImage(
            with: content.posterImageURL,
            placeholderImage: .placeholderPoster
        )
        releaseDateLabel.text = content.releaseDate
        budgetLabel.text = content.budget
        revenueLabel.text = content.revenue
        voteView.configureWith(content: content.vote)
    }
    
    final func changeImage(isCollapsedStage: Bool) {
        guard isAnimationCompleted,
              isCollapsedStage != detailStack.isHidden else { return }
        changeViewState(for: isCollapsedStage)
    }
}

// MARK: - Configuration
private extension MovieHeaderView {
    final func setupViews() {
        setInitalHeight()
        configureContainerView()
        configureImageViews()
        configureLabels()
    }
    
    final func setInitalHeight() {
        posterHeight.constant = MovieHeaderView.expendedHeight
    }
    
    final func configureContainerView() {
        backgroundColor = .backgroundPrimary
        layerShadowColor = .white.withAlphaComponent(0.1)
        layerShadowOffset = .init(width: 0, height: 12)
        layerShadowOpacity = 1
        layerShadowRadius = 8
    }
    
    final func configureImageViews() {
        posterImageView.cornerRadius = 4
        posterImageView.borderColor = .separator
        posterImageView.borderWidth = 2
        
        budgetImageView.image = .budget
        revenueImageView.image = .revenue
    }
    
    final func configureLabels() {
        titleLabel.textColor = .white.withAlphaComponent(0.9)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = .bold(24)
        titleLabel.numberOfLines = 0
        
        originalTitleLabel.textColor = .lightText
        originalTitleLabel.font = .mediumItalic(18)
        
        releaseDateLabel.textColor = .lightText
        releaseDateLabel.font = .medium(14)
        
        budgetLabel.font = .medium(14)
        budgetLabel.textColor = .lightText
        
        budgetTitleLabel.font = .medium(14)
        budgetTitleLabel.textColor = .lightText
        budgetTitleLabel.text = L10nMovieHeader.budget.localized()
        
        revenueLabel.font = .medium(14)
        revenueLabel.textColor = .lightText
        
        revenueTitleLabel.font = .medium(14)
        revenueTitleLabel.textColor = .lightText
        revenueTitleLabel.text = L10nMovieHeader.revenue.localized()
    }
}

// MARK: - Configuration
private extension MovieHeaderView {
    final func changeViewState(for isCollapsedStage: Bool) {
        isAnimationCompleted = false
        
        let detectedPosterHeight: CGFloat = isCollapsedStage ? MovieHeaderView.collapsedHeight : MovieHeaderView.expendedHeight
        let detectedTitleFont: UIFont? = isCollapsedStage ? .bold(28) : .bold(24)
        let detectedBackgroundColor: UIColor? = isCollapsedStage ? .darkText : .backgroundPrimary
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            detailStack.isHidden = isCollapsedStage
            originalTitleLabel.isHidden = isCollapsedStage || originalTitleLabel.text == titleLabel.text
            
            UIView.animate(
                withDuration: Constants.Duration.animation,
                animations: { [weak self] in
                    guard let self else { return }
                    posterHeight.constant =  detectedPosterHeight
                    titleLabel.font = detectedTitleFont
                    backgroundColor = detectedBackgroundColor
                    layoutIfNeeded()
                },
                completion: { [weak self] isCompleted in
                    guard let self else { return }
                    isAnimationCompleted = isCompleted
                }
            )
        }
    }
}
