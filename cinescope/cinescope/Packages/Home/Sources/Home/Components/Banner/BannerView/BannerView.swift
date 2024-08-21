//
//  BannerView.swift
//
//
//  Created by Ozan Barış Günaydın on 28.12.2023.
//

import UIKit
import Components
import AppResources

// MARK: - BannerView
final class BannerView: UIView, NibOwnerLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - Typealias
    private typealias Cell = BannerCellView

    // MARK: - UI Components
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: StackedPageControl!

    // MARK: - Global Variables
    private var timer: Timer?
    private var remainPage = 0
    private var currentIndex: Int {
        return collectionView.indexPathsForVisibleItems.first?.row ?? 0
    }

    // MARK: - Constants
    private let pageMultiplierConstant = 100
    private let autoScrollWaitingSecond: Double = 10
    static let widthToHeightRatio: CGFloat = 281 / 500

    // MARK: - Data
    private var bannerSelectionCallback: ((Int) -> Void)?
    private var shouldAutoScroll = false
    private var shouldInfiniteScroll = false
    private var banners: [BannerContent] = [] {
        didSet {
            collectionView.reloadData { [weak self] in
                guard let self else { return }
                self.setupBanners()
            }
        }
    }

    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
    }

    // MARK: - Setup
    private func setupViews() {
        configureContainerView()
        configureCollectionView()
        configurePageControl()
    }

    // MARK: - LifeCycle
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            /// View's Disappear
            invalidateTimer()
        } else {
            /// View's Appear
            configureTimer()
        }
    }
}

// MARK: - Public
extension BannerView {
    /// Configures view with giving properies
    /// - Parameters:
    ///   - shouldAutoScroll: Optional Boolean value for auto scroll
    ///   - shouldInfiniteScroll: Optional Boolean value for infinite scroll
    ///   - bannerSelectionCallback: Optinal block value for selection of banner
    final func configureWith(
        shouldAutoScroll: Bool = false,
        shouldInfiniteScroll: Bool = false,
        bannerSelectionCallback: ((Int) -> Void)? = nil
    ) {
        self.shouldAutoScroll = shouldAutoScroll
        self.shouldInfiniteScroll = shouldInfiniteScroll
        self.bannerSelectionCallback = bannerSelectionCallback
    }

    /// Sets the needed datas of view.
    /// - Parameters:
    ///   - banners: Array of Banner's model value for banner items.
    final func setContentWith(
        banners: [BannerContent]
    ) {
        self.banners = banners
        pageControl.numberOfPages = banners.count
    }
}

// MARK: - Configuration
private extension BannerView {
    final func configureContainerView() {
        backgroundColor = .clear
    }

    final func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = flowLayout
        collectionView.backgroundColor = .clear
        collectionView.register(
            nibWithCellClass: Cell.self,
            at: Bundle.module
        )

        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true

        collectionView.layer.masksToBounds = false
        collectionView.layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.1).cgColor
        collectionView.layer.shadowOpacity = 1.0
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 8)
        collectionView.layer.shadowRadius = 8
    }

    final func configurePageControl() {
        pageControl.configureWith(alignment: .all)
    }
}

// MARK: - Helpers
private extension BannerView {
    /// Check the banners data and starts the timer with scrolling middle page of the collection view for infinite scrolling. Also sets the page control's current page.
    final func setupBanners() {
        guard !banners.isEmpty else { return }

        if shouldInfiniteScroll {
            configureFor(
                currentIndex: getMiddlePage(),
                animated: false
            )
        }

        pageControl.currentPage = 0
        configureTimer()
    }

    /// Detects the index's situation for infinite scrolling and scrolls the collection view given cell automatically.
    /// - Parameter currentIndex: Given index for the auto scroll.
    final func configureFor(currentIndex: Int, animated: Bool = true) {
        /// Scroll the collection view on the gived index for auto scrolling.
        let offset = (currentIndex.cgFloat * collectionView.width)
        collectionView.setContentOffset(
            CGPoint(x: offset, y: 0),
            animated: animated
        )
    }

    /// If the timers is not nil then invalidates the `timer`
    final func invalidateTimer() {
        guard timer != nil  else { return }
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Timer Helpers
@objc private extension BannerView {
    /// If the auto scroll is enabled then trigger the scroll mechanism to next banner.
    final func didEndTimer() {
        guard shouldAutoScroll else { return }
        configureFor(currentIndex: currentIndex + 1)
    }

    /// If the auto scroll is enabled then trigger the timer for starting auto scroll.
    final func configureTimer() {
        guard !banners.isEmpty,
              shouldAutoScroll else { return }
        invalidateTimer()
        timer = Timer.scheduledTimer(
            timeInterval: autoScrollWaitingSecond,
            target: self,
            selector: #selector(didEndTimer),
            userInfo: nil,
            repeats: true
        )
    }
}

// MARK: - Scroll Helpers
private extension BannerView {
    /// Calculates the total pages number of collection view will show.
    /// - Returns: Int value of total pages count
    final func getTotalPageCount() -> Int {
        let infiniteScrollCount = (banners.count * pageMultiplierConstant)
        return shouldInfiniteScroll ? infiniteScrollCount : banners.count
    }

    /// Takes the total page count of collection view's and calculates the middile page.
    /// - Returns: Int value of middle page's row.
    final func getMiddlePage() -> Int {
        return getTotalPageCount() / 2
    }

    /// Takes the row and return moded by dataSource count of collectionView.
    /// - Parameter row: Int value of row for collection view.
    /// - Returns: Int value for moded by campaigns count which is the dataSource of collectionView.
    final func getModedRow(_ row: Int) -> Int? {
        guard !banners.isEmpty else { return nil }
        let modedRow = row % (banners.count)
        return shouldInfiniteScroll ? modedRow : row
    }

    /// Calculate the actual row of collection view on real data.
    /// - Parameter row: Int value for collection view's current indexPath.row.
    /// - Returns: Return the real value of row for cell's loading.
    final func getIndexRow(_ row: Int) -> Int {
        let detectedRow = row == 0 ? 0 : getModedRow(row) ?? 0
        return shouldInfiniteScroll ? detectedRow : row
    }

    /// Takes the page width and scroll view's (collectionView's) content offset's x value and calculates the new page index number. If the detected page number is equal the saved (remain) page number it's return nil because of the preventing overriding same value.
    /// - Parameters:
    ///   - pageWidth: CGFloat value for the page width (cell size width)
    ///   - contentOffsetX: CGFloat value for collection view's content offset of x axis
    /// - Returns: Optional Int value for new page index number.
    final func getPageIndex(
        with pageWidth: CGFloat,
        contentOffsetX: CGFloat
    ) -> Int? {
        let pageNumber = Int(floor((contentOffsetX - pageWidth / 2) / pageWidth) + 1)
        let detectedPageNumber = getIndexRow(pageNumber)
        guard remainPage != detectedPageNumber else { return nil }

        remainPage = detectedPageNumber
        return detectedPageNumber
    }
}
// MARK: - UICollectionViewDelegate
extension BannerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let bannerSelectionCallback,
              let movieID = banners[safe: getModedRow(indexPath.row) ?? 0]?.movieID else { return }
        bannerSelectionCallback(movieID)
    }
}

// MARK: - UICollectionViewDataSource
extension BannerView: UICollectionViewDataSource {
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return getTotalPageCount()
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withClass: Cell.self,
            for: indexPath
        )

        let reducedIndexPathRow = getIndexRow(indexPath.row)
        guard let banner = banners[safe: reducedIndexPathRow] else { return cell }

        cell.configureWith(content: banner)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BannerView: UICollectionViewDelegateFlowLayout {
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = .screenWidth - (.spacingLarge * 2)
        let height = width * BannerView.widthToHeightRatio

        return CGSize(width: width, height: height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .spacingLarge * 2
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: 0,
            left: .spacingLarge,
            bottom: 0,
            right: .spacingLarge
        )
    }
}

// MARK: - UIScrollViewDelegate
extension BannerView: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        configureTimer()
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let frameWidth = scrollView.frame.width

        let pageIndex = getPageIndex(
            with: frameWidth,
            contentOffsetX: contentOffsetX
        )
        guard let pageIndex else { return }
        pageControl.currentPage = pageIndex
    }
}
