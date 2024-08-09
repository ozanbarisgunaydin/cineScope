//
//  BasePanModalViewController.swift
//
//
//  Created by Ozan Barış Günaydın on 13.12.2023.
//
import AppResources
import Utility
import UIKit
import PanModal

// MARK: - Typealias
public typealias PanModalCompletion = () -> Void

// MARK: - BasePanModalViewController
open class BasePanModalViewController: UIViewController, PanModalPresentable {
    // MARK: - Public Data
    public var dismissCompletion: PanModalCompletion?
    public var alertManager = AlertManager.shared

    /// Should change after the super.viewDidLoad() method called
    /// Since this is changed on the base's viewDidLoad method.
    public var isDragIndicatorVisible: Bool {
        get {
            return dragIndicator.isHidden
        }
        set {
            dragIndicator.bringSubviewToFront(view)
            dragIndicator.isHidden = !newValue
        }
    }

    // MARK: - UI Variables
    private lazy var dragIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    // MARK: - Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupUI()
        isDragIndicatorVisible = true
    }

    open func setupUI() { }

    // MARK: - Setup
    private func setupViews() {
        view.addSubview(dragIndicator)
        dragIndicator.cornerRadius = 2
        view.backgroundColor = .white
        dragIndicator.backgroundColor = .darkGray.withAlphaComponent(0.5)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dragIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0),
            dragIndicator.heightAnchor.constraint(equalToConstant: 4.0),
            dragIndicator.widthAnchor.constraint(equalToConstant: 30.0),
            dragIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Publics
    public var panScrollable: UIScrollView? {
        return nil
    }

    open var topOffset: CGFloat {
        return 0
    }

    open var shortFormHeight: PanModalHeight {
        return .intrinsicHeight
    }

    open var longFormHeight: PanModalHeight {
        return .intrinsicHeight
    }

    open var allowsTapToDismiss: Bool {
        return true
    }

    open var allowsDragToDismiss: Bool {
        return true
    }

    open var showDragIndicator: Bool {
        return false
    }

    open var panModalBackgroundColor: UIColor {
        return .black.withAlphaComponent(0.6)
    }

    open var transitionAnimationOptions: UIView.AnimationOptions {
        return [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState]
    }

    open var shouldRoundTopCorners: Bool {
        return true
    }

    open var cornerRadius: CGFloat {
        return 16
    }

    open var springDamping: CGFloat {
        return 0.8
    }

    open var transitionDuration: Double {
        return 0.3
    }

    public func panModalWillDismiss() {
        dismissKeyboard()
    }

    public func panModalDidDismiss() {
        dismissCompletion?()
    }
}
