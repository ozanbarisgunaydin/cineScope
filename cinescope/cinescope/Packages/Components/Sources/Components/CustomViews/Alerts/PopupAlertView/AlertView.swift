//
//  AlertView.swift
//
//
//  Created by Ozan Barış Günaydın on 21.12.2023.
//

import AppResources
import Combine
import UIKit
import Utility

// MARK: - AlertView
final public class AlertView: UIView, NibLoadable {
    // MARK: - Bundle
    public static var module = Bundle.module
    
    // MARK: - UI Components
    /// Containers
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var dismissButton: UIButton!
    @IBOutlet private weak var alertContainerView: UIView!
    /// Image Views
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var constraintImageHeight: NSLayoutConstraint!
    @IBOutlet private weak var imageViewLeading: NSLayoutConstraint!
    @IBOutlet private weak var imageViewTopPadding: NSLayoutConstraint!
    @IBOutlet private weak var imageViewTrailing: NSLayoutConstraint!
    /// Labels
    @IBOutlet private weak var infoContainerView: UIView!
    @IBOutlet private weak var labelTitle: CustomLabel!
    @IBOutlet private weak var messageContainerView: UIView!
    @IBOutlet private weak var labelMessage: CustomLabel!
    /// Buttons
    @IBOutlet private weak var buttonContainerView: UIView!
    @IBOutlet private weak var buttonStack: UIStackView!
    @IBOutlet private weak var closeButton: UIButton!
    
    // MARK: - Private Variables
    private var isOutsideTapEnabled: Bool {
        return content?.dismissStyle == .all || content?.dismissStyle == .outsideTap
    }
    private var isCloseButtonEnabled: Bool {
        return content?.dismissStyle == .all || content?.dismissStyle == .closeButton
    }
    
    // MARK: - Data
    public var cancellables: [AnyCancellable] = []
    private var content: AlertContent?
    
    // MARK: - Init
    public override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    // MARK: - Publics
    public func configureAlertView(
        with content: AlertContent
    ) {
        self.content = content
        setLabelTexts()
        setImage()
        checkAndAddDefaultAction()
        setButtonArrangement()
        setButtonActions()
    }
}

// MARK: - Publics
public extension AlertView {
    final func show() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        alertContainerView.fadeIn(duration: 0.25)
        backgroundView.fadeIn(duration: 0.25)
        
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                guard let self else { return }
                alertContainerView.transform = CGAffineTransform(scaleX: 1, y: 1)
            },
            completion: nil
        )
    }
}

// MARK: - Configuration
private extension AlertView {
    final func configureViews() {
        configureContainerViews()
        configureTitleLabel()
        configureMessageLabel()
        configureButtonStacks()
        configureCloseButton()
        configureDismissButton()
        layoutIfNeeded()
    }
    
    final func configureContainerViews() {
        alertContainerView.cornerRadius = AlertConstants.Container.cornerRadius
        alertContainerView.alpha = 0
        alertContainerView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        imageContainerView.isHidden = true
        imageContainerView.contentMode = .scaleAspectFit
        
        infoContainerView.isHidden = true
    }
    
    final func configureTitleLabel() {
        labelTitle.font = AlertConstants.Font.title
        labelTitle.textColor = .pearlBlack
        labelTitle.numberOfLines = 0
        labelTitle.text = ""
        labelTitle.textAlignment = .center
    }
    
    final func configureMessageLabel() {
        labelMessage.font = AlertConstants.Font.message
        labelMessage.textColor = .pearlBlack
        labelMessage.numberOfLines = 0
        labelMessage.text = ""
        labelMessage.textAlignment = .center
    }
    
    final func configureButtonStacks() {
        buttonContainerView.isHidden = true
        buttonStack.removeAllArrangedSubviews()
    }
    
    final func configureCloseButton() {
        closeButton.setTitleForAllStates("")
        closeButton.setImageForAllStates(.iconClose)
        closeButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self,
                isCloseButtonEnabled else { return }
                hide { [weak self] _ in
                    guard let self else { return }
                    content?.closeTapHandler?()
                }
            }
            .store(in: &cancellables)
    }
    
    final func configureDismissButton() {
        dismissButton.setTitleForAllStates("")
        dismissButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self,
                      isOutsideTapEnabled else { return }
                hide { [weak self] _ in
                    guard let self else { return }
                    content?.outsideTapHandler?()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Helpers
private extension AlertView {
    final func setLabelTexts() {
        if let title = content?.title {
            infoContainerView.isHidden = false
            labelTitle.text = title
        }
        
        if let message = content?.message {
            infoContainerView.isHidden = false
            labelMessage.text = message
        }
    }
    
    final func setImage() {
        guard let asset = content?.asset else { return }
        imageContainerView.isHidden = false
        constraintImageHeight.constant = AlertConstants.Image.height
        imageView.image = asset
    }
    
    final func checkAndAddDefaultAction() {
        guard (content?.actions ?? []).isEmpty else { return }
        let defaultAction = AlertAction(
            title: L10nGeneric.okay.localized(),
            style: .primary
        )
        
        add(action: defaultAction)
    }
    
    final func setButtonArrangement() {
        buttonContainerView.isHidden = false
        
        if (content?.actions ?? []).count <= 2 {
            buttonStack.axis = .horizontal
            buttonStack.distribution = .fillEqually
        } else {
            buttonStack.axis = .vertical
            buttonStack.distribution = .fillProportionally
        }
        
        closeButton.isHidden = !isCloseButtonEnabled
    }
    
    final func setButtonActions() {
        guard let actions = content?.actions else { return }
        
        for (index, action) in actions.enumerated() {
            configureButton(on: index, for: action)
        }
    }
    
    final func configureButton(on index: Int, for action: AlertAction) {
        guard action.title != nil else { return }
        let button = Button(type: .custom)
        /// Properties
        button.tag = index
        button.buttonStyle = action.style
        button.cornerRadius = AlertConstants.Button.cornerRadius
        button.setTitleForAllStates(action.title ?? L10nGeneric.okay.localized())
        
        /// Action
        button
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                actionSelected(on: index)
            }
            .store(in: &cancellables)
        
        /// Constraint
        button.heightAnchor.constraint(
            equalToConstant: AlertConstants.Button.height
        ).isActive = true
        
        buttonStack.addArrangedSubview(button)
    }
    
    final func actionSelected(on index: Int) {
        guard let actions = content?.actions,
              let action = actions[safe: index] else { return }
        
        content?.selectedActionHandler?(action)
        
        if content?.shouldDismissHandler == nil || content?.shouldDismissHandler?(action) != false {
            hide { [weak self] _ in
                guard let self else { return }
                content?.selectedActionCompletionHandler?(action)
                action.handler?(action)
            }
        } else {
            content?.selectedActionCompletionHandler?(action)
            action.handler?(action)
        }
    }
    
    final func add(action: AlertAction) {
        if (content?.actions ?? []).isEmpty {
            content?.actions = [action]
        } else {
            content?.actions?.append(action)
        }
    }
    
    final func hide(completion: ((Bool) -> Void)? = nil) {
        alertContainerView.fadeOut(duration: 0.2)
        backgroundView.fadeOut(duration: 0.2)
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                guard let self else { return }
                self.alertContainerView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
            },
            completion: { [weak self] finished in
                guard let self else { return }
                completion?(finished)
                removeFromSuperview()
            }
        )
    }
}
