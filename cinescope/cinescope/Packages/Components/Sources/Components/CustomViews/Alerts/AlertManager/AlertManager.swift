//
//  AlertManager.swift
//
//
//  Created by Ozan Barış Günaydın on 21.12.2023.
//

import AppResources
import PanModal
import UIKit

// MARK: - AlertStyle
public enum AlertStyle {
    case popup
    case bottomSheet
}

// MARK: - DismissStyle
public enum DismissStyle: Int {
    case none
    case closeButton
    case outsideTap
    case all
}

// MARK: - AlertManager
public class AlertManager: NSObject {
    // MARK: - Shared
    public static var shared = AlertManager()
    
    // MARK: - Init
    private override init() { }
    
    // MARK: - Publics
    public func showAlert(
        from viewController: UIViewController? = nil,
        content: AlertContent
    ) {
        if content.style == .bottomSheet {
            let alert = BottomSheetAlertViewController(content: content)
            let controller = viewController ?? UIApplication.topViewController()
            controller?.presentPanModal(alert)
        } else {
            let alert = AlertView.loadFromNib()
            
            if content.shouldBringToFront ?? false {
                guard let view = UIWindow.key else { return }
                view.addSubview(alert)
            } else {
                guard let view = viewController?.view ?? UIApplication.shared.currentWindow else { return }
                view.addSubview(alert)
            }
            
            alert.fillToSuperview()
            alert.configureAlertView(with: content)

            alert.show()
        }
    }
}
