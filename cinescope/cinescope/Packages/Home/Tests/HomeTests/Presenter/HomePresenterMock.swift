//
//  HomePresenterMock.swift
//
//
//  Created by Ozan Barış Günaydın on 21.08.2024.
//

import Combine
import Components
import Foundation
@testable import Home


// MARK: - HomePresenterMock
class HomePresenterMock: HomePresenterProtocol {
    // MARK: - Base Parameters
    var isLoading = PassthroughSubject<Bool, any Error>()
    var alert = PassthroughSubject<AlertContent?, any Error>()
    var cancellables: [AnyCancellable] = []
    var router: BaseRouterProtocol?
    
    // MARK: - Protocol Parameters
    var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol = HomeInteractorMock()
    
    // MARK: - Published Parameters
    @Published var banners: [BannerContentModel] = []
    var bannerPublisher: Published<[BannerContentModel]>.Publisher { $banners }
    @Published var content: [HomeContent] = []
    var contentPublisher: Published<[HomeContent]>.Publisher { $content }

    // MARK: - Test Indicators
    var mockGetSectionPropertiesOutput: (type: HomeSectionType, itemCount: Int)?
    var isFetchContentCalled = false
    var calledGetSectionPropertiesIndex: Int?
    var calledRouteToMovieDetailMovieID: Int?
    var calledRouteToGenreSearchIndex: Int?
    var calledRouteToCategorySearchType: CategoryType?
    var calledRouteToPeopleSearchIndex: Int?
    
    // MARK: - Methods
    func fetchContent() {
        isFetchContentCalled = true
    }
    
    func getSectionProperties(for index: Int) -> (type: HomeSectionType, itemCount: Int)? {
        calledGetSectionPropertiesIndex = index
        return mockGetSectionPropertiesOutput
    }
    
    func routeToMovieDetail(for movieID: Int) {
        calledRouteToMovieDetailMovieID = movieID
    }
    
    func routeToGenreSearch(on index: Int) {
        calledRouteToGenreSearchIndex = index
    }
    
    func routeToCategorySearch(on type: CategoryType) {
        calledRouteToCategorySearchType = type
    }
    
    func routeToPeopleSearch(on index: Int) {
        calledRouteToPeopleSearchIndex = index
    }
}
