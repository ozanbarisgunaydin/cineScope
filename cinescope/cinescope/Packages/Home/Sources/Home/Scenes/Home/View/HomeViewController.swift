//
//  HomeViewController.swift
//  
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import AppResources
import Components
import UIKit

// MARK: - HomeViewControllerProtocol
protocol HomeViewProtocol: AnyObject  {
    var presenter: HomePresenterProtocol? { get set }
}

// MARK: - HomeViewController
class HomeViewController: BaseViewController, HomeViewProtocol {

    var presenter: HomePresenterProtocol?

    // MARK: - Life Cycles
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
    }
    
    // MARK: - Observe
    override func observeContent() {
        super.observeContent()
        
    }
}
