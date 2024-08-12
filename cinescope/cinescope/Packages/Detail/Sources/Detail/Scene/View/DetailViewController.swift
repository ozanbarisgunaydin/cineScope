//
//  DetailViewController.swift
//  
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import Components
import UIKit

// MARK: - HomeViewControllerProtocol
protocol DetailViewProtocol: AnyObject  {
    var presenter: DetailPresenterProtocol? { get set }
}

// MARK: - HomeViewController
final class DetailViewController: BaseViewController, DetailViewProtocol {
    // MARK: - Outlets
    
    // MARK: - Components
    var presenter: DetailPresenterProtocol? {
        get { return basePresenter as? DetailPresenterProtocol }
        set { basePresenter = newValue }
    }

    // MARK: - Life Cycles
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Interface Configuration
    override func configureInterface() {
        super.configureInterface()
    }
    
    // MARK: - Observe
    override func observeContent() {
        super.observeContent()
    }
    
    // MARK: - Init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Interface Configuration
private extension DetailViewController {
    final func configureNavigationBar() {
    }
}
