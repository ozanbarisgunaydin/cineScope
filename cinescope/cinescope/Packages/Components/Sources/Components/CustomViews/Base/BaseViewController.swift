//
//  BaseViewController.swift
//
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import AppResources
import Combine
import Utility
import UIKit

// MARK: - BaseViewController
open class BaseViewController: UIViewController, BaseViewControllerProtocol, UIGestureRecognizerDelegate {
    // MARK: - Base Components
    public var basePresenter: BasePresenterProtocol?
    
    // MARK: - Data
    public var cancellables: [AnyCancellable] = []
    
    // MARK: - Alert
    public var alertSelectedActionHandler: ((AlertAction) -> Void)?
    public var alertOutsideTapHandler: (() -> Void)?
    public var alertManager = AlertManager.shared
    
    // MARK: - UI Configurators
    public var navigationBarColor: UIColor = .backgroundNavBar
    public var dividerColor = UIColor.separator
    public var shouldShowNavigationBar = true
    public var shouldShowBackButton = true
    public var shouldShowDivider = true

    // MARK: - Privates
    private let dividerView = UIView()

    // MARK: - Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        configureInterface()
        setNavigationProperties()
        observeContent()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkNavigationBar()
    }

    open func configureInterface() {
    }

    // MARK: - Data Observe
    open func observeContent() {
        observeLoading()
        observeAlert()
    }

    open func observeLoading() {
        basePresenter?.isLoading
            .sink { _ in } receiveValue: { [weak self] isLoading in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    set(isLoading, isInteractionEnabled: true)
                }
            }
            .store(in: &cancellables)
    }

    open func observeAlert() {
        basePresenter?.alert
            .sink { _ in } receiveValue: { [weak self] alertContent in
                guard let self,
                      var alertContent else { return }
                set(false, isInteractionEnabled: true)

                alertContent.selectedActionCompletionHandler = { [weak self] alertAction in
                    guard let self else { return }
                    self.alertSelectedActionHandler?(alertAction)
                    guard alertContent.shouldGoBackOnDismiss == true else { return }
                }
                
                alertContent.outsideTapHandler = { [weak self] in
                    guard let self else { return }
                    self.alertOutsideTapHandler?()
                    guard alertContent.shouldGoBackOnDismiss == true else { return }
                }
                
                showAlert(with: alertContent)
            }
            .store(in: &cancellables)
    }

    @objc open func didTapBackButton() {
        if isModal {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - Set Loading HUD
public extension BaseViewController {
    final func set(_ isLoading: Bool, isInteractionEnabled: Bool = false) {
        if isLoading {
            showLoading(isInteractionEnabled: isInteractionEnabled)
        } else {
            hideLoading()
        }
    }
}

// MARK: - Navigation Bar
public extension BaseViewController {
    final func setNavigationBarBackButton(
        backButtonImage: UIImage? = .chevronLeft
    ) {
        /// Sets navigation bar's tint color
        navigationController?.navigationBar.tintColor = .white

        /// Sets custom back button image
        guard let navigationController else { return }
        if shouldShowBackButton {
            let resizedBackButtonImage = backButtonImage?.resized(to: CGSize(width: 20, height: 20))

            let backButton = UIBarButtonItem(
                image: resizedBackButtonImage,
                style: .plain,
                target: self,
                action: #selector(didTapBackButton)
            )

            navigationItem.leftBarButtonItem = backButton
        } else {
            navigationItem.setHidesBackButton(true, animated: false)
        }

        /// Override native back button
        let appearance = UINavigationBarAppearance()
        appearance.backButtonAppearance.normal.backgroundImage = backButtonImage
        /// Clears native back button text
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]

        /// Sets navigation bar's background color
        appearance.backgroundColor = navigationBarColor
        appearance.shadowColor = .clear

        /// Sets navigation bar's title attributes
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.bold(16)
        ]
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - Privates
private extension BaseViewController {
    final func setNavigationProperties() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = shouldShowBackButton
    }

    final func showLoading(isInteractionEnabled: Bool = false) {
        guard let keyWindow = UIWindow.key else { return }
        keyWindow.showHUD(isUserInteractionEnabled: isInteractionEnabled)
    }

    final func hideLoading() {
        guard let keyWindow = UIWindow.key else { return }
        keyWindow.hideHUD()
    }

    final func checkNavigationBar() {
        navigationController?.setNavigationBarHidden(!shouldShowNavigationBar, animated: true)

        if shouldShowNavigationBar {
            setNavigationBarBackButton()

            if shouldShowDivider {
                addDividerView()
            } else {
                removeDividerView()
            }
        } else {
            removeDividerView()
        }
    }

    final func addDividerView() {
        dividerView.backgroundColor = dividerColor
        view.addSubview(dividerView)

        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    final func removeDividerView() {
        dividerView.removeFromSuperview()
    }
}
