//
//  SplashViewController.swift
//  
//
//  Created by Ozan Barış Günaydın on 7.08.2024.
//

import AppResources
import Lottie
import Components
import UIKit

// MARK: - SplashViewProtocol
protocol SplashViewProtocol: AnyObject {
}

// MARK: - SplashViewController
public class SplashViewController: BaseViewController {
    // MARK: - Components
    var presenter: SplashPresenterProtocol!
    
    // MARK: - Constants
    private let length: CGFloat = 256

    // MARK: - Life Cycles
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    public override func configureInterface() {
        super.configureInterface()
        configureNavigationBar()
        configureBackgroundView()
        configureWelcomeAnimation()
    }
}

// MARK: - Interface Configuration
private extension SplashViewController {
    final func configureNavigationBar() {
        shouldShowNavigationBar = false
    }
    
    final func configureBackgroundView() {
        view.backgroundColor = .backgroundPrimary
    }
    
    final func configureWelcomeAnimation() {
        let animation = LottieAnimation.named("splashAnimation", bundle: AppResources.bundle)
        
        let animationView = LottieAnimationView(animation: animation)
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFill
        
        view.addSubview(animationView)
        animationView.anchorCenterSuperview()
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalToConstant: length),
            animationView.widthAnchor.constraint(equalToConstant: length)
        ])

        animationView.play { [weak self] _ in
            guard let self else { return }
            presenter.routeToTabBar()
        }
    }
}

// MARK: - SplashViewControllerProtocol
extension SplashViewController: SplashViewProtocol {
    /* no - op */
}
