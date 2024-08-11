//
//  TitleHeaderView.swift
//
//
//  Created by Ozan Barış Günaydın on 9.05.2024.
//

import UIKit
import Components
import AppResources

// MARK: - TitleHeaderView
final public class TitleHeaderView: UICollectionReusableView, NibLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var titleLabel: CustomLabel!

    // MARK: - Initialization
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

// MARK: - Configuration
public extension TitleHeaderView {
    final func configureWith(
        title: String?
    ) {
        titleLabel.text = title
    }
}

// MARK: - Configuration
private extension TitleHeaderView {
    final func setupViews() {
        configureContainerView()
        configureTitle()
    }

    final func configureContainerView() {
        backgroundColor = .clear
    }

    final func configureTitle() {
        titleLabel.font = .bold(16)
        titleLabel.textColor = .white
    }
}
