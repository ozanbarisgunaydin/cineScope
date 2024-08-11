//
//  GenreHeaderView.swift
//
//
//  Created by Ozan Barış Günaydın on 9.05.2024.
//

import UIKit
import Combine
import Components
import AppResources

// MARK: - GenreHeaderView
final public class GenreHeaderView: UICollectionReusableView, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: CustomLabel!
    @IBOutlet private weak var badgeView: UIView!
    @IBOutlet private weak var countLabel: CustomLabel!
    @IBOutlet private weak var contentButton: UIButton!
    @IBOutlet private weak var gradientView: UIView!

    // MARK: Constants
    static let viewSize = CGSize(width: 122, height: 114)

    // MARK: - Data
    private var cancellables: [AnyCancellable] = []
    private var selectionCallback: (() -> Void)?

    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Configuration
extension GenreHeaderView {
    final func configureWith(
        content: HomeGenreListContent?,
        selectionCallback: (() -> Void)?
    ) {
        imageView.image = content?.image
        titleLabel.text = content?.title
        countLabel.text = content?.badge
        self.selectionCallback = selectionCallback
    }
}

// MARK: - Configuration
private extension GenreHeaderView {
    final func setupViews() {
        configureContainerView()
        configureTitle()
        configureBadge()
        configureContentButton()
        configureGradientView()
    }

    final func configureContainerView() {
        backgroundColor = .clear

        backgroundView.backgroundColor = .backgroundPrimary

        containerView.backgroundColor = .black
        containerView.borderColor = .separator
        containerView.borderWidth = 1
        containerView.cornerRadius = 14
    }

    final func configureTitle() {
        titleLabel.font = .bold(14)
        titleLabel.textColor = .white
    }

    final func configureBadge() {
        badgeView.setCapsuleCornerRadius()
        badgeView.backgroundColor = .systemRed

        countLabel.font = .bold(12)
        countLabel.textColor = .white
    }

    final func makeThemeUpdates() {
        containerView.borderColor = .separator
    }

    final func configureContentButton() {
        contentButton.setTitleForAllStates("")
        contentButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                self.selectionCallback?()
            }
            .store(in: &cancellables)
    }

    final func configureGradientView() {
        gradientView.backgroundColor = .backgroundPrimary
        let gradient = CAGradientLayer(layer: gradientView.layer)
        gradient.frame = gradientView.bounds
        gradient.colors = [
            UIColor.backgroundPrimary.cgColor,
            UIColor.clear.cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradientView.layer.mask = gradient
    }
}
