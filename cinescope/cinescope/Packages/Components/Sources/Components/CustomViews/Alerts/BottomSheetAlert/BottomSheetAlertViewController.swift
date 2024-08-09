//
//  BottomSheetAlertViewController.swift
//
//
//  Created by Ozan Barış Günaydın on 21.12.2023.
//

import AppResources
import Combine
import UIKit
import Utility

// MARK: - BottomSheetAlertViewController
public class BottomSheetAlertViewController: BasePanModalViewController {
    // MARK: - UI Components
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var alertContainerView: UIView!
    @IBOutlet private weak var imageContainerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var constraintImageHeight: NSLayoutConstraint!
    @IBOutlet private weak var infoContainerView: UIView!
    @IBOutlet private weak var labelTitle: CustomLabel!
    @IBOutlet private weak var messageContainerView: UIView!
    @IBOutlet private weak var labelMessage: CustomLabel!
    @IBOutlet private weak var buttonContainerView: UIView!
    @IBOutlet private weak var buttonStack: UIStackView!
    @IBOutlet private weak var seperatorView: UIView!
    @IBOutlet private weak var closeButton: UIButton!
    
    // MARK: - Private Variables
    private var isActionDismissTriggered = false
    private var isOutsideTapEnabled: Bool {
        return content.dismissStyle == .all || content.dismissStyle == .outsideTap
    }
    private var isCloseButtonEnabled: Bool {
        return content.dismissStyle == .all || content.dismissStyle == .closeButton
    }
    
    // MARK: - Data
    public var cancellables: [AnyCancellable] = []
    private var content: AlertContent

    // MARK: - Life Cycles
    public override func viewDidLoad() {
        super.viewDidLoad()
        isDragIndicatorVisible = true
        setLabelTexts()
        setImage()
        checkAndAddDefaultAction()
        setButtonArrangement()
        setButtonActions()
    }

    // MARK: - Setup
    public override func setupUI() {
        super.setupUI()
        configureViews()
    }

    // MARK: - Init
    public init(
        content: AlertContent
    ) {
        self.content = content
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Pan Modal Overrides
    public override var allowsTapToDismiss: Bool {
        return isOutsideTapEnabled
    }

    public override var allowsDragToDismiss: Bool {
        return isOutsideTapEnabled
    }

    public override func panModalDidDismiss() {
        super.panModalDidDismiss()
        guard !isActionDismissTriggered, isOutsideTapEnabled else { return }
        content.outsideTapHandler?()
    }
}

// MARK: - Configuration
private extension BottomSheetAlertViewController {
    final func configureViews() {
        configureContainerViews()
        configureTitleLabel()
        configureMessageLabel()
        configureButtonStacks()
        configureCloseButton()
        configureSeperatorView()
    }
    
    final func prepareUI() {
        buttonContainerView.isHidden = true
        buttonStack.removeAllArrangedSubviews()
        view.layoutIfNeeded()
    }
    
    final func configureContainerViews() {
        view.backgroundColor = .backgroundPrimary
        containerView.backgroundColor = .backgroundPrimary
        
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
                dismiss(animated: true) { [weak self] in
                    guard let self else { return }
                    content.closeTapHandler?()
                }
            }
            .store(in: &cancellables)
    }
    
    final func configureSeperatorView() {
        seperatorView.backgroundColor = .separator
    }
}

// MARK: - Helpers
private extension BottomSheetAlertViewController {
    final func setImage() {
        guard let asset = content.asset else { return }
        imageContainerView.isHidden = false
        constraintImageHeight.constant = AlertConstants.Image.height
        imageView.image = asset
    }
    
    final func setLabelTexts() {
        if let title = content.title {
            infoContainerView.isHidden = false
            labelTitle.text = title
        }
        
        if let message = content.message {
            infoContainerView.isHidden = false
            labelMessage.text = message
            labelMessage.sizeToFit()
        }
    }
    
    final func checkAndAddDefaultAction() {
        guard (content.actions ?? []).isEmpty else { return }
        let defaultAction = AlertAction(
            title: L10nGeneric.okay.localized(),
            style: .primary
        )
        
        add(action: defaultAction)
    }
    
    final func setButtonArrangement() {
        buttonContainerView.isHidden = false
        
        if (content.actions ?? []).count <= 2 {
            buttonStack.axis = .horizontal
            buttonStack.distribution = .fillEqually
        } else {
            buttonStack.axis = .vertical
            buttonStack.distribution = .fillProportionally
        }
        
        closeButton.isHidden = !isCloseButtonEnabled
    }
    
    final func setButtonActions() {
        guard let actions = content.actions else { return }
        
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
        guard let actions = content.actions,
              let action = actions[safe: index] else { return }
        
        content.selectedActionHandler?(action)
        
        if content.shouldDismissHandler == nil || content.shouldDismissHandler?(action) != false {
            isActionDismissTriggered = true
            dismiss(animated: true) { [weak self] in
                guard let self else { return }
                content.selectedActionCompletionHandler?(action)
                action.handler?(action)
            }
        } else {
            content.selectedActionCompletionHandler?(action)
            action.handler?(action)
        }
    }
    
    final func add(action: AlertAction) {
        if (content.actions ?? []).isEmpty {
            content.actions = [action]
        } else {
            content.actions?.append(action)
        }
    }
}
