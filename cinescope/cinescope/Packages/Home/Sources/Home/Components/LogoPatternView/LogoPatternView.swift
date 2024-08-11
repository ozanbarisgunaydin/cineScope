//
//  LogoPatternView.swift
//
//
//  Created by Ozan Barış Günaydın on 3.05.2024.
//

import Components
import UIKit

// MARK: - LogoPatternView
final public class LogoPatternView: UIView, NibOwnerLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var baseImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!

    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
    }
}

// MARK: - Configuration
private extension LogoPatternView {
    final func setupViews() {
        configureContainerView()
        configureImageViews()
    }

    final func configureContainerView() {
        backgroundColor = .clear
    }

    final func configureImageViews() {
        baseImageView.image = .patternBase
        logoImageView.image = .logoNamed
    }
}
