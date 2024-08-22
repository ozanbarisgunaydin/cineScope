//
//  HomeRouterTests.swift
//
//
//  Created by Ozan Barış Günaydın on 22.08.2024.
//

import XCTest
@testable import Home

// MARK: - HomeRouterTests
final class HomeRouterTests: XCTestCase {
    // MARK: - Test Initializations
    var router: HomeRouter!
    
    override func setUp() {
        super.setUp()
        router = HomeRouter(UINavigationController())
    }
    
    override func tearDown() {
        router = nil
        super.tearDown()
    }
    
    // MARK: - Test Methods
    func testGetModule_ShouldSetUpViewControllerAndDependencies() {
        let viewController = router.getModule()
        
        XCTAssertTrue(viewController is UINavigationController, "Expected a UINavigationController")
        
        let navigationController = viewController as? UINavigationController
        let rootViewController = navigationController?.viewControllers.first
        
        XCTAssertTrue(rootViewController is HomeViewController, "Expected root view controller to be HomeViewController")
        
        let homeViewController = rootViewController as? HomeViewController
        XCTAssertNotNil(homeViewController?.presenter, "Expected presenter to be set")
        
        XCTAssertTrue(homeViewController?.presenter is HomePresenter, "Expected presenter to be of type HomePresenter")
        
        let presenter = homeViewController?.presenter as? HomePresenter
        XCTAssertNotNil(presenter?.interactor, "Expected interactor to be set")
        XCTAssertNotNil(presenter?.router, "Expected router to be set")
        
        XCTAssertTrue(presenter?.router === router, "Expected presenter router to be the same as the router instance")
    }
}
