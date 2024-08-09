//
//  File.swift
//
//
//  Created by Ozan Barış Günaydın on 8.08.2024.
//

import Combine
import Foundation

// MARK: - HomePresenterProtocol
protocol HomePresenterProtocol {
    /// Variables
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorProtocol { get set }
    var router: HomeRouterProtocol { get set }
    var todoPublisher: Published<String?>.Publisher { get }
    /// Functions
    func fetch()
}

// MARK: - HomePresenter
final class HomePresenter: HomePresenterProtocol {
    // MARK: - Components
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorProtocol
    var router: HomeRouterProtocol
    
    init(
        view: HomeViewProtocol,
        interactor: HomeInteractorProtocol,
        router: HomeRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Private Variables
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Published Variables
    @Published var todo: String?
    var todoPublisher: Published<String?>.Publisher { $todo }
    
    // MARK: - Functions
    func fetch() {
//        interactor?.fetch().sink(
//            receiveCompletion: { completion in
//                print(completion)
//            }, receiveValue: { [weak self] todo in
//                self?.todo = todo
//            }
//        )
//        .store(in: &cancellables)
    }
}
