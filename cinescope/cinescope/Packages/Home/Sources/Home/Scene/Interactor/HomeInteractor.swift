//
//  HomeInteractor.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import Combine
import Foundation

// MARK: - HomeInteractorProtocol
protocol HomeInteractorProtocol {
    /// Variables
    var dummyValue: PassthroughSubject<String?, Error> { get set }
    /// Functions
    func fetch()
}

// MARK: - HomeInteractor
class HomeInteractor: HomeInteractorProtocol {
    // MARK: - Observable Objects
    public var dummyValue = PassthroughSubject<String?, Error>()

    // MARK: - Functions
    func fetch() {
        dummyValue.send("deneme")
    }
}
