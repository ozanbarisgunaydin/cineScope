//
//  BaseViewControllerProtocol.swift
//  
//
//  Created by Ozan Barış Günaydın on 8.12.2023.
//

import Foundation
import UIKit

public protocol BaseViewControllerProtocol {
    func observeContent()
    func set(_ isLoading: Bool, isInteractionEnabled: Bool)
}
