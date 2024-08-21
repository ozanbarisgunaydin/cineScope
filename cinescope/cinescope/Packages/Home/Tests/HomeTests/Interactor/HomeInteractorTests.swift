//
//  HomeInteractorTests.swift
//
//
//  Created by Ozan Barış Günaydın on 21.08.2024.
//
import AppManagers
import Combine
import Network
import XCTest
@testable import Home

// MARK: - HomeInteractorTests
final class HomeInteractorTests: XCTestCase {
    // MARK: - Test Initializations
    var sut: HomeInteractor!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = HomeInteractor()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testFetchPopularMovies_WhenResultIsSuccess_ShouldRecieveData() {
        let mockResponse = HomeContentDataMock.getPopularMovies
        let mockNetworkManager = NetworkManagerMock(
            isSuccess: true,
            response: mockResponse
        )
        sut.network = mockNetworkManager
        
        runTest(
            method: sut.fetchPopularMovies(),
            mockResponse: mockResponse?.results,
            isSuccess: true
        )
    }
    
    func testFetchPopularMovies_WhenResultIsFailure_ShouldNotRecieveData() {
        let mockNetworkManager = NetworkManagerMock(isSuccess: false)
        sut.network = mockNetworkManager
        
        runTest(
            method: sut.fetchPopularMovies(),
            isSuccess: false
        )
    }
    
    func testFetchMovieGenres_WhenResultIsSuccess_ShouldRecieveData() {
        let mockResponse = HomeContentDataMock.getMovieGenres
        let mockNetworkManager = NetworkManagerMock(
            isSuccess: true,
            response: mockResponse
        )
        sut.network = mockNetworkManager
        
        runTest(
            method: sut.fetchMovieGenres(),
            mockResponse: mockResponse?.genres,
            isSuccess: true
        )
    }
    
    func testFetchMovieGenres_WhenResultIsFailure_ShouldNotRecieveData() {
        let mockNetworkManager = NetworkManagerMock(isSuccess: false)
        sut.network = mockNetworkManager
        runTest(
            method: sut.fetchMovieGenres(),
            isSuccess: false
        )
    }
    
    func testFetchTrendPeople_WhenResultIsSuccess_ShouldRecieveData() {
        let mockResponse = HomeContentDataMock.getTrendPeople
        let mockNetworkManager = NetworkManagerMock(
            isSuccess: true,
            response: mockResponse
        )
        sut.network = mockNetworkManager
        
        runTest(
            method: sut.fetchPeopleList(),
            mockResponse: mockResponse?.results,
            isSuccess: true
        )
    }
    
    func testFetchTrendPeople_WhenResultIsFailure_ShouldNotRecieveData() {
        let mockNetworkManager = NetworkManagerMock(isSuccess: false)
        sut.network = mockNetworkManager
        
        runTest(
            method: sut.fetchPeopleList(),
            isSuccess: false
        )
    }
}

// MARK: - Private Extension for Test Helpers
private extension HomeInteractorTests {
    func runTest<T: Decodable & Equatable>(
        method: AnyPublisher<[T]?, BaseError>,
        mockResponse: [T]? = nil,
        isSuccess: Bool
    ) {
        let expectation = XCTestExpectation(description: #function)
        method.sink(
            receiveCompletion: { completion in
                guard case .failure(let error) = completion else { return }
                if isSuccess {
                    XCTFail("Expected success, got error: \(error)")
                } else {
                    XCTAssertNotNil(error)
                    expectation.fulfill()
                }
            },
            receiveValue: { value in
                if isSuccess {
                    XCTAssertEqual(value, mockResponse)
                    expectation.fulfill()
                }
            }
        ).store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
