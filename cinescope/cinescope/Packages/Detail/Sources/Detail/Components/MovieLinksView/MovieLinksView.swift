//
//  MovieLinksView.swift
//
//
//  Created by Ozan Barış Günaydın on 14.08.2024.
//

import Combine
import Components
import UIKit

// MARK: - MovieLinksView
final class MovieLinksView: UIView, NibOwnerLoadable {
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var titleView: MovieSectionTitleView!
    
    @IBOutlet private weak var homeLinkContainerView: UIView!
    @IBOutlet private weak var homeLinkBackgroundImageView: UIImageView!
    @IBOutlet private weak var homeLinkBackgroundView: UIView!
    @IBOutlet private weak var homeLinkClickImageView: UIImageView!
    @IBOutlet private weak var homeLinkTitleLabel: UILabel!
    @IBOutlet private weak var homeLinkButton: UIButton!
    
    @IBOutlet private weak var imdbContainerView: UIView!
    @IBOutlet private weak var imdbImageView: UIImageView!
    @IBOutlet private weak var imdbClickImageView: UIImageView!
    @IBOutlet private weak var imdbButton: UIButton!
    
    // MARK: - Constants
    
    // MARK: - Data
    private var cancellables: [AnyCancellable] = []
	private var imdbURL: String?
	private var homePageURL: String?
    private var hyperLinkCallback: ((String) -> Void)?
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
    }
}

// MARK: - Publics
extension MovieLinksView {
    final func configureWith(
        content: MovieLinksContent,
        hyperLinkCallback: ((String) -> Void)?
    ) {
        homeLinkBackgroundImageView.loadImage(with: content.backgroundImageURL)
        self.imdbURL = content.imdbURL
        self.homePageURL = content.homePageURL
        self.hyperLinkCallback = hyperLinkCallback
    }
}

// MARK: - Configuration
private extension MovieLinksView {
    final func setupViews() {
        configureContainerView()
        configureTitleLabel()
        configureHomeLinkViews()
        configureImdbViews()
    }
    
    final func configureContainerView() {
        backgroundColor = .clear
        [
            homeLinkContainerView,
            imdbContainerView
        ].forEach { view in
            view?.cornerRadius = 6
            view?.borderColor = .separator
            view?.borderWidth = 2
        }
        
        [
            homeLinkClickImageView,
            imdbClickImageView
        ].forEach { iamgeView in
            iamgeView?.image = .hyperlink
        }
    }
    
    final func configureTitleLabel() {
        titleView.configureWith(
            isSeparatorHidden: true,
            title: L10nMovieLinks.title.localized()
        )
    }
    
    final func configureHomeLinkViews() {
        homeLinkBackgroundImageView.contentMode = .scaleAspectFill
        
        homeLinkBackgroundView.backgroundColor = .clear
        homeLinkBackgroundView.addBlurOverlay(with: .systemMaterialDark)
        
        homeLinkTitleLabel.textColor = .white
        homeLinkTitleLabel.font = .bold(14)
        homeLinkTitleLabel.text = L10nMovieLinks.moviePage.localized()
        
        homeLinkButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self,
                	  let hyperLinkCallback,
                      let homePageURL else { return }
                hyperLinkCallback(homePageURL)
            }
            .store(in: &cancellables)
    }
    
    final func configureImdbViews() {
        imdbImageView.image = .imdbLogo
        
        imdbContainerView.backgroundColor = .imdbYellow
        
        imdbButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self,
                      let hyperLinkCallback,
                      let imdbURL else { return }
                hyperLinkCallback(imdbURL)
            }
            .store(in: &cancellables)
    }
}
