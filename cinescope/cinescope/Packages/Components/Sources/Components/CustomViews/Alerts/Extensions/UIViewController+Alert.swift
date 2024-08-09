//
//  UIViewController+Alert.swift
//
//
//  Created by Ozan Barış Günaydın on 21.12.2023.
//

import UIKit
import AppResources

// MARK: - BaseViewController
public extension BaseViewController {
    // MARK: - Show
    func showAlert(with content: AlertContent) {
        alertManager.showAlert(
            from: self,
            content: content
        )
    }
}
