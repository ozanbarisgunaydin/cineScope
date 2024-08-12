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
final class HomeViewController: BaseViewController, HomeViewProtocol {
    // MARK: - Typealias
    typealias GenreHeader = GenreHeaderView
    typealias TitleHeader = TitleHeaderView
    typealias GenreCell = GenreCellView
    typealias CategoryCell = CategoryCellView
    typealias PersonCell = PersonCellView
    
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
    
    // MARK: - Data
    var dataSource: UICollectionViewDiffableDataSource<HomeSectionType, AnyHashable>?
    
    // MARK: - Global Variables
    private var shouldGiveScrollOffset = false
    private var scrollOffset: CGFloat = 0

    // MARK: - Life Cycles
    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchContent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldGiveScrollOffset = true
    }
    
    // MARK: - Interface Configuration
    override func configureInterface() {
        super.configureInterface()
        configureNavigationBar()
        configureContainerView()
        configureBannerView()
        configureCollectionView()
        configureFadeOutView()
    }
    
    // MARK: - Observe
    override func observeContent() {
        super.observeContent()
        observeBanners()
        observeCollectionContent()
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
    
    final func observeCollectionContent() {
        presenter?.contentPublisher
            .sink { [weak self] content in
                guard let self,
                      !content.isEmpty else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    guard let self else { return }
                    applySnapshot(with: content)
                }
         
            }
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
        ) { [weak self] movieID in
            guard let self else { return }
            presenter?.routeToMovieDetail(for: movieID)
        }
    }
    
    final func configureCollectionView() {
        setCollectionViewPropeties()
        registerCells()
        configureDataSource()
        setScrollInsets()  
    }
    
    final func setCollectionViewPropeties() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        
        collectionView.backgroundColor = .backgroundPrimary
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    final func registerCells() {
        collectionView.registerReusableView(
            nibWithViewClass: GenreHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            at: Bundle.module
        )
        collectionView.registerReusableView(
            nibWithViewClass: TitleHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            at: Bundle.module
        )
        collectionView.register(
            nibWithCellClass: GenreCell.self,
            at: Bundle.module
        )
        collectionView.register(
            nibWithCellClass: CategoryCell.self,
            at: Bundle.module
        )
        collectionView.register(
            nibWithCellClass: PersonCell.self,
            at: Bundle.module
        )
    }
    
    final func setScrollInsets() {
        let bannerMaxY = bannerView.convert(
            CGPoint(
                x: 0,
                y: bannerView.bounds.maxY
            ),
            to: view
        ).y + .paddingMedium
        let bannerYOffset = bannerMaxY - collectionView.frame.minY
        collectionView.contentInset = .init(
            top: bannerYOffset,
            left: 0,
            bottom: 2 * CGFloat.spacingLarge,
            right: 0
        )
    }
    
    final func configureFadeOutView() {
        collectionFadeOutView.setGradientBackground(
            colors: [
                .backgroundPrimary,
                .backgroundPrimary.withAlphaComponent(0.1)
            ],
            locations: [0, 1]
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
    
    final func applyBannerGradientMask(on scrollDistance: CGFloat) {
        let shadowPadding: CGFloat = 32
        let gradientHeight: CGFloat = 8
        let scrollRatio = (-scrollDistance + shadowPadding - gradientHeight) / (bannerView.height + (2 * shadowPadding))
        let gradientRatio = gradientHeight / bannerView.height
        let lastPoint = scrollRatio >= 1 ? 1 : scrollRatio
        let absLastPoint = lastPoint > 0 ? lastPoint : 0
        let middleColor: UIColor = absLastPoint == 0 ? .backgroundPrimary : .clear
        let gradient = CAGradientLayer(layer: bannerView.layer)
        gradient.frame = .init(
            x: bannerView.bounds.minX,
            y: bannerView.bounds.minY - shadowPadding,
            width: bannerView.bounds.width,
            height: bannerView.bounds.height + (2 * shadowPadding)
        )
        gradient.colors = [
            UIColor.clear.cgColor,
            middleColor.cgColor,
            UIColor.backgroundPrimary.cgColor,
            UIColor.backgroundPrimary.cgColor
        ]
        gradient.locations = [
            0,
            NSNumber(value: absLastPoint),
            NSNumber(value: absLastPoint + gradientRatio),
            1
        ]
        bannerView.layer.mask = gradient
    }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldGiveScrollOffset else {
            scrollOffset = scrollView.contentOffset.y
            return
        }
        
        let scrollDistance = -(scrollView.contentOffset.y) + scrollOffset
        applyBannerScrollOffset(on: scrollDistance)
        applyBannerGradientMask(on: scrollDistance)
    }
}
