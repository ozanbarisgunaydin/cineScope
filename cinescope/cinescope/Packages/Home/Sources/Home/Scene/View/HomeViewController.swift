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
    
    // MARK: - Outlets
    @IBOutlet private weak var logoPatternView: LogoPatternView!
    @IBOutlet weak var bannerView: BannerView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionFadeOutView: UIView!

    var presenter: HomePresenterProtocol?

    // MARK: - Life Cycles
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Interface Configuration
    override func configureInterface() {
        super.configureInterface()
        configureNavigationBar()
        configureContainerView()
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

// MARK: - Confguration
private extension HomeViewController {
    final func configureNavigationBar() {
        shouldShowNavigationBar = false
    }
    
    final func configureContainerView() {
        view.backgroundColor = .backgroundPrimary
    }
}
