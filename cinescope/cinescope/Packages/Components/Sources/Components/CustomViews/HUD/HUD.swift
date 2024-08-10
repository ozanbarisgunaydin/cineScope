//
//  HUD.swift
//  kapida
//
//  Created by Ozan Barış Günaydın on 24.02.2023.
//

import AppResources
import Lottie
import UIKit
import Utility

public enum HUD {
    static func show(isUserInteractionEnabled: Bool = false) {
        DispatchQueue.main.async {
            guard let keyWindow = UIWindow.key else { return }
            keyWindow.showHUD(isUserInteractionEnabled: isUserInteractionEnabled)
        }
    }

    static func show(
        on viewController: UIViewController,
        isUserInteractionEnabled: Bool = false
    ) {
        viewController.showHUD(isUserInteractionEnabled: isUserInteractionEnabled)
    }

    static func show(
        on view: UIView,
        isUserInteractionEnabled: Bool = false
    ) {
        view.showHUD(isUserInteractionEnabled: isUserInteractionEnabled)
    }

    static func dismiss() {
        DispatchQueue.main.async {
            guard let keyWindow = UIWindow.key else { return }
            keyWindow.hideHUD()
        }
    }

    static func dismiss(from viewController: UIViewController) {
        viewController.hideHUD()
    }

    static func dismiss(from view: UIView) {
        view.hideHUD()
    }
}

internal extension UIViewController {
    func showHUD(isUserInteractionEnabled: Bool = false) {
        view.showHUD(isUserInteractionEnabled: isUserInteractionEnabled)
    }

    func hideHUD() {
        view.hideHUD()
    }
}

internal extension UIView {
    func showHUD(isUserInteractionEnabled: Bool = false, widthHeight: CGFloat = 128) {
        guard viewWithTag(1967) == nil else { return }
        let widthHeight: CGFloat = widthHeight
        let frame = CGRect(
            x: UIScreen.main.bounds.width - (widthHeight / 2),
            y: UIScreen.main.bounds.height - (widthHeight / 2),
            width: widthHeight,
            height: widthHeight
        )

        let containerView = UIView(frame: UIScreen.main.bounds)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        containerView.alpha = 0
        containerView.tag = 1967
        containerView.isUserInteractionEnabled = !isUserInteractionEnabled
        addSubview(containerView)
        containerView.fillToSuperview()

        let animation = LottieAnimation.named("hudLoader", bundle: AppResources.bundle)
        let indicatorView = LottieAnimationView(animation: animation)
        indicatorView.loopMode = .loop
        indicatorView.animationSpeed = 3.0
        indicatorView.backgroundBehavior = .pauseAndRestore
        indicatorView.frame = frame

        containerView.addSubview(indicatorView)
        indicatorView.anchorCenterSuperview()
        NSLayoutConstraint.activate([
            indicatorView.heightAnchor.constraint(equalToConstant: widthHeight),
            indicatorView.widthAnchor.constraint(equalToConstant: widthHeight)
        ])
        indicatorView.play()

        containerView.fadeIn(duration: 0.3)
    }

    func hideHUD() {
        guard let loadingContainer = self.viewWithTag(1967) else { return }
        loadingContainer.fadeOut(duration: 0.3) { _ in
            loadingContainer.subviews.forEach { view in
                view.removeFromSuperview()
            }
            loadingContainer.removeFromSuperview()
        }
    }
}
