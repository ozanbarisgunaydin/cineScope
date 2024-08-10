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
    
    // MARK: - Components
    public var presenter: HomePresenterProtocol? {
        get { return basePresenter as? HomePresenterProtocol }
        set { basePresenter = newValue }
    }

    // MARK: - Life Cycles
    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchContent()
    }
    
    // MARK: - Interface Configuration
    override func configureInterface() {
        super.configureInterface()
        configureNavigationBar()
        configureContainerView()
        configureBannerView()
    }
    
    // MARK: - Observe
    override func observeContent() {
        super.observeContent()
        observeBanners()
    }
    
    // MARK: - Init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Observers
private extension HomeViewController {
    final func observeBanners() {
        presenter?.bannerPublisher.sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { [weak self] banners in
            guard let self else { return }
            bannerView.setContentWith(banners: banners)
        })
        .store(in: &cancellables)
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
    
    final func configureBannerView() {
        bannerView.configureWith(
            shouldAutoScroll: true,
            shouldInfiniteScroll: true
        )
    }
}

// MARK: - Helpers
private extension HomeViewController {
    final func applyBannerScrollOffset(on scrollDistance: CGFloat) {
        bannerView.transform = CGAffineTransform(
            translationX: 0,
            y: scrollDistance
        )
    }
}
