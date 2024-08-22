//
//  HomePresenterTests.swift
//
//
//  Created by Ozan Barış Günaydın on 22.08.2024.
//

import AppManagers
import AppResources
import Combine
import XCTest
@testable import Home

// MARK: - HomePresenterTests
final class HomePresenterTests: XCTestCase {
    // MARK: - Test Initializations
    var sut: HomePresenter!
    var view: HomeViewControllerMock!
    var interactor: HomeInteractorMock!
    var router: HomeRouterMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        view = HomeViewControllerMock()
        interactor = HomeInteractorMock()
        router = HomeRouterMock(UINavigationController())
        cancellables = []
        sut = HomePresenter(
            view: view,
            interactor: interactor,
            router: router
        )
    }
    
    override func tearDown() {
        sut = nil
        view = nil
        interactor = nil
        router = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testFetchContentSuccess_ShouldFillPublishers() {
        let popularMovies = HomeContentDataMock.getPopularMovies?.results
        fillContent(popularMovies: popularMovies)

        let expectation = XCTestExpectation(description: #function)
        sut.$banners
            .sink { banners in
                XCTAssertEqual(banners.count, popularMovies?.count)
                XCTAssertEqual(banners.first?.title, popularMovies?.first?.title)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        let contentCount = 3 /// Genres + Category + People
        sut.$content
            .sink { content in
                XCTAssertEqual(content.count, contentCount)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchContentFailure_ShouldNotFillPublishers() {
        setFailureContent()
        
        let expectation = XCTestExpectation(description: #function)
        sut.$banners
            .sink { banners in
                XCTAssertEqual(banners.count, 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.$content
            .sink { content in
                XCTAssertEqual(content.count, 1) /// 1 is the static category section's count
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetSectionProperties_WhenContentIsFilled_ShouldReturnExistedProperties() {
        let mockGenreList = [Genre()]
        fillContent(genres: mockGenreList)
        
        let expectation = XCTestExpectation(description: #function)
        let detectedIndex = 0
        let desiredSectionProperties = (
            type: HomeSectionType.genreList(headerTitle: L10nHome.genres.localized(in: Bundle.module)),
            itemCount: mockGenreList.count
        )
        sut.$content
            .sink { [weak self] content in
                guard let self else { return }
                XCTAssertEqual(
                    sut.getSectionProperties(for: detectedIndex)?.type,
                    desiredSectionProperties.type
                )
                XCTAssertEqual(
                    sut.getSectionProperties(for: detectedIndex)?.itemCount,
                    desiredSectionProperties.itemCount
                )
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetSectionProperties_WhenContentIsEmpty_ShouldReturnStaticContent() {
        setFailureContent()
        let staticCategoryContent = (
            type: HomeSectionType.categories(
                headerTitle: L10nHome.discover.localized(in: Bundle.module)
            ),
            itemCount: 4
        )
        
        let expectation = XCTestExpectation(description: #function)
        sut.$content
            .sink { [weak self] content in
                guard let self else { return }
                XCTAssertEqual(
                    sut.getSectionProperties(for: 0)?.type,
                    staticCategoryContent.type
                )
                XCTAssertEqual(
                    sut.getSectionProperties(for: 0)?.itemCount,
                    staticCategoryContent.itemCount
                )
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetSectionProperties_WhenIndexOutOfRange_ShouldReturnNil() {
        setFailureContent()
        
        let expectation = XCTestExpectation(description: #function)
        sut.$content
            .sink { [weak self] content in
                guard let self else { return }
                XCTAssertNil(sut.getSectionProperties(for: 1))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRouteToDetail_ShouldCallRouter_WithGivenMovieID() {
        let mockMovieID = 4161
        sut.routeToMovieDetail(for: mockMovieID)
        
        XCTAssertEqual(router.calledMovieID, mockMovieID)
    }
    
    func testRouteToGenreSearch_WhenGenresIsFilled_ShouldCallRouter() {
        let dummyGenre = Genre(id: 4161, name: "Action")
        performGenreSearchTest(
            genres: [dummyGenre],
            genreIndex: 0,
            expectedGenre: dummyGenre
        )
    }
    
    func testRouteToGenreSearch_WhenGenresNotHaveID_ShouldNotCallRouter() {
        let dummyGenre = Genre(name: "Action")
        performGenreSearchTest(
            genres: [dummyGenre],
            genreIndex: 0,
            expectedGenre: nil
        )
    }
    
    func testRouteToGenreSearch_WhenCalledGenreIndexIsNotExist_ShouldNotCallRouter() {
        performGenreSearchTest(
            genres: nil,
            genreIndex: 1,
            expectedGenre: nil
        )
    }
    
    func testRouteToCategorySearch_ShouldCallNowPlayingType() {
        setCategoryRouteCallTest(selectedCategoryType: .nowPlaying)
    }
    
    func testRouteToCategorySearch_ShouldCallPopularType() {
        setCategoryRouteCallTest(selectedCategoryType: .popular)
    }    
    
    func testRouteToCategorySearch_ShouldCallTopRatedType() {
        setCategoryRouteCallTest(selectedCategoryType: .topRated)
    }    
    
    func testRouteToCategorySearch_ShouldCallUpComingdType() {
        setCategoryRouteCallTest(selectedCategoryType: .upComing)
    }
    
    func testRouteToPeopleSearch_WhenPeopleIsFilled_ShouldCallRouter() {
        let dummyPeople = [
            PeopleContent(id: 4161, name: "Taylor Swift", originalName: "Taylor Swift")
        ]
        performRouteToPeopleSearchTest(
            peopleList: dummyPeople,
            detectedIndex: 0,
            expectedName: dummyPeople[0].name
        )
    }
    
    func testRouteToPeopleSearch_WhenPeopleIsFilledWithoutOriginalName_ShouldNotCallRouter() {
        let dummyPeople = [PeopleContent(id: 4161, name: "Taylor Swift")]
        performRouteToPeopleSearchTest(
            peopleList: dummyPeople,
            detectedIndex: 0
        )
    }
    
    func testRouteToPeopleSearch_WhenPeopleHasOutOfIDLimitID_ShouldNotCallRouter() {
        let dummyPeople = [PeopleContent(id: Constants.Default.maxIDLimit + 61, name: "Taylor Swift")]
        performRouteToPeopleSearchTest(
            peopleList: dummyPeople,
            detectedIndex: 0
        )
    }
    
    func testRouteToPeopleSearch_WhenPeopleNotHaveID_ShouldNotCallRouter() {
        let dummyPeople = [PeopleContent(name: "Taylor Swift")]
        performRouteToPeopleSearchTest(
            peopleList: dummyPeople,
            detectedIndex: 0
        )
    }
    
    func testRouteToPeopleSearch_WhenPeopleIndexIsNotExist_ShouldNotCallRouter() {
        performRouteToPeopleSearchTest(
            peopleList: nil,
            detectedIndex: 0
        )
    }
}

// MARK: - Helpers
private extension HomePresenterTests {
    /// Fills the content by setting success results for popular movies, genres, and people list.
    /// Therefore,  triggers the content fetching process in the system under test (SUT).
    final func fillContent(
        popularMovies: [Movie]? = HomeContentDataMock.getPopularMovies?.results,
        genres: [Genre]? = HomeContentDataMock.getMovieGenres?.genres,
        peopleList: [PeopleContent]? = HomeContentDataMock.getTrendPeople?.results
    ) {
        interactor.fetchPopularMoviesResult = .success(popularMovies)
        interactor.fetchMovieGenresResult = .success(genres)
        interactor.fetchPeopleListResult = .success(peopleList)
        
        sut.fetchContent()
    }
    
    /// Sets failure results for popular movies, genres, and people list, and then triggers the content fetching process in the system under test (SUT).
    final func setFailureContent() {
        interactor.fetchPopularMoviesResult = .failure(.init())
        interactor.fetchMovieGenresResult = .failure(.init())
        interactor.fetchPeopleListResult = .failure(.init())
        
        sut.fetchContent()
    }
    
    /// Sets up a test for routing to a category search.
    /// It fills the content with nil genres, triggers the category search route for the given category type.
    /// In result, verifies that the router is called with the correct category type.
    final func setCategoryRouteCallTest(
        selectedCategoryType: CategoryType
    ) {
        fillContent(genres: nil)
        
        let expectation = XCTestExpectation(description: #function)
        sut.$content
            .sink { [weak self] content in
                guard let self else { return }
                sut.routeToCategorySearch(on: selectedCategoryType)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)
        
        
        XCTAssertEqual(router.calledCategoryType, selectedCategoryType)
    }  
    
    /// Performs a test for routing to a genre search.
    /// It fills the content with the given genres, triggers the genre search route for the specified genre index.
    /// Therefore, verifies that the router is called with the expected genre.
    func performGenreSearchTest(
        genres: [Genre]?,
        genreIndex: Int,
        expectedGenre: Genre?
    ) {
        fillContent(genres: genres)
        
        let expectation = XCTestExpectation(description: #function)
        sut.$content
            .sink { [weak self] content in
                guard let self else { return }
                sut.routeToGenreSearch(on: genreIndex)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)
        
        if let expectedGenre {
            XCTAssertEqual(router.calledGenre, expectedGenre)
        } else {
            XCTAssertNil(router.calledGenre)
        }
    }
    
    /// Performs a test for routing to a people search.
    /// It fills the content with the given people list, triggers the people search route for the specified index, and verifies that the router is called with the expected name and people content.
    /// If provided, or ensures that the router is not called otherwise.
    func performRouteToPeopleSearchTest(
        peopleList: [PeopleContent]?,
        detectedIndex: Int,
        expectedName: String? = nil,
        expectedCalledPeople: PeopleContent? = nil
    ) {
        fillContent(peopleList: peopleList)
        
        let expectation = XCTestExpectation(description: #function)
        sut.$content
            .sink { [weak self] content in
                guard let self else { return }
                sut.routeToPeopleSearch(on: detectedIndex)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 1.0)
        
        if let expectedName {
            XCTAssertEqual(router.calledPeople?.name, expectedName)
            
            if let expectedCalledPeople {
                XCTAssertEqual(router.calledPeople, expectedCalledPeople)
            } else {
                XCTAssertNotEqual(router.calledPeople, expectedCalledPeople)
            }
        } else {
            XCTAssertNil(router.calledPeople)
        }
    }
}
