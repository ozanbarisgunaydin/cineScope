//
//  VoteView.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import UIKit
import Components

// MARK: - VoteView
final class VoteView: UIView, NibOwnerLoadable {
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var voteImageView: UIImageView!
    @IBOutlet private weak var voteAverageLabel: UILabel!
    @IBOutlet private weak var voteCountLabel: UILabel!
    
    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
    }
}

// MARK: - Publics
extension VoteView {
    final func configureWith(
        content: VoteContent?
    ) {
        voteAverageLabel.text = content?.average
        voteCountLabel.text = "(\(content?.count ?? "0")\(L10nMovieHeader.votes.localized()))"
    }
}

// MARK: - Configuration
private extension VoteView {
    final func setupViews() {
        configureContainerView()
        configureImageView()
        configureLabels()
    }
    
    final func configureContainerView() {
        backgroundColor = .clear
        containerView.backgroundColor = .backgroundPrimary.withAlphaComponent(0.4)
        containerView.borderColor = .separator
        containerView.borderWidth = 2
        containerView.cornerRadius = 4
    }
    
    final func configureImageView() {
        voteImageView.image = .star
    }
    
    final func configureLabels() {
        voteCountLabel.textColor = .lightText
        voteCountLabel.font = .medium(10)
        
        voteAverageLabel.textColor = .white
        voteAverageLabel.font = .bold(14)
    }
}
