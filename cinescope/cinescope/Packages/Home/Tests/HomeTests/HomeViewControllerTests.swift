import AppResources
import Combine
import XCTest
@testable import Home

// MARK: - HomeViewControllerTests
final class HomeViewControllerTests: XCTestCase {
    // MARK: - Test Initializations
    var sut: HomeViewController!
    var presenter: HomePresenterMock!
    
    override func setUp() {
        super.setUp()
        sut = HomeViewController()
        presenter = HomePresenterMock()
        sut.presenter = presenter
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testViewDidLoad_shouldCallsFetchContent() {
        sut.loadViewIfNeeded()
        XCTAssertTrue(presenter.isFetchContentCalled)
    }
    
    func testViewDidAppear_shouldChangesScrollOffsetBoolean() {
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        XCTAssertTrue(sut.shouldGiveScrollOffset)
    }
    
    func testItemSelection_ShouldCallMovieDetail() {
        let mockMovieID = 4161
        presenter.banners = HomeContentDataMock.getBannerContent(movieID: mockMovieID)
        
        sut.loadViewIfNeeded()
        sut.bannerView.collectionView(
            sut.bannerView.collectionView,
            didSelectItemAt: IndexPath(item: 0, section: 0)
        )
        
        XCTAssertEqual(presenter.calledRouteToMovieDetailMovieID, mockMovieID)
    }
    
    func testItemSelection_WhenBannersIsNotFilled_ShouldNotCallRoute() {
        sut.loadViewIfNeeded()
        sut.bannerView.collectionView(
            sut.bannerView.collectionView,
            didSelectItemAt: IndexPath(item: 0, section: 0)
        )
        XCTAssertNil(presenter.calledRouteToMovieDetailMovieID)
    }
    
    func testItemSelection_ShouldCallCategorySearch() {
        let mockCategoryOption: CategoryType = .nowPlaying
        presenter.content = HomeContentDataMock.getCategoryContent(type: mockCategoryOption)
        sut.loadViewIfNeeded()
        
        setExpectationWithAction(
            expextationName: #function,
            duration: Constants.Duration.animation
        ) { [weak self] in
            guard let self else { return }
            sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        }
        
        XCTAssertEqual(presenter.calledRouteToCategorySearchType, mockCategoryOption)
    }
    
    func testItemSelection_ShouldCallGenreSearch() {
        let mockGenreIndex = 0
        presenter.content = HomeContentDataMock.getGenreContent(index: mockGenreIndex)
        sut.loadViewIfNeeded()

        setExpectationWithAction(
            expextationName: #function,
            duration: Constants.Duration.animation
        ) { [weak self] in
            guard let self else { return }
            sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        }
        
        XCTAssertEqual(presenter.calledRouteToGenreSearchIndex, mockGenreIndex)
    }
    
    func testItemSelection_ShouldCallPeopleSearch() {
        let mockCelebrityIndex = 0
        presenter.content = HomeContentDataMock.getCelebrityContent(index: mockCelebrityIndex)
        sut.loadViewIfNeeded()
        
        setExpectationWithAction(
            expextationName: #function,
            duration: Constants.Duration.animation
        ) { [weak self] in
            guard let self else { return }
            sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        }
        
        XCTAssertEqual(presenter.calledRouteToPeopleSearchIndex, mockCelebrityIndex)
    }
    
    func testItemSelection_WhenItemIsNotFilled_ShouldNotCallRoutes() {
        sut.loadViewIfNeeded()
        sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))

        XCTAssertNil(presenter.calledRouteToCategorySearchType)
        XCTAssertNil(presenter.calledRouteToGenreSearchIndex)
        XCTAssertNil(presenter.calledRouteToPeopleSearchIndex)
    }
}

// MARK: - Helpers
private extension HomeViewControllerTests {
    func setExpectationWithAction(
        expextationName: String,
        duration: Double,
        action: @escaping (() -> Void)
    ) {
        let expectation = XCTestExpectation(description: expextationName)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            action()
            expectation.fulfill()
        }
        
        XCTWaiter().wait(
            for: [expectation],
            timeout: 1
        )
    }
}
