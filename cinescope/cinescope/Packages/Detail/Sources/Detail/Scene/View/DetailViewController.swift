//
//  DetailViewController.swift
//  
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import Components
import UIKit

// MARK: - HomeViewControllerProtocol
protocol DetailViewProtocol: AnyObject  {
    var presenter: DetailPresenterProtocol? { get set }
}

// MARK: - HomeViewController
final class DetailViewController: BaseViewController, DetailViewProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var headerView: MovieHeaderView!
    
    // MARK: - Components
    var presenter: DetailPresenterProtocol? {
        get { return basePresenter as? DetailPresenterProtocol }
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
        configureScrollView()
    }
    
    // MARK: - Observe
    override func observeContent() {
        super.observeContent()
        observeMovie()
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
private extension DetailViewController {
    final func observeMovie() {
        presenter?.headerPublisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] headerContent in
                guard let self,
                      let headerContent else { return }
                headerView.configureWith(content: headerContent)
            })
        .store(in: &cancellables)
    }
}


// MARK: - Interface Configuration
private extension DetailViewController {
    final func configureNavigationBar() {
        title = L10nDetail.title.localized()
    }
    
    final func configureScrollView() {
        scrollView.delegate = self
        scrollView.contentInset.top = 8
    }
}


// MARK: - Interface Configuration
extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isScrollLimitReached = scrollView.contentOffset.y > 16
        headerView.changeImage(isCollapsedStage: isScrollLimitReached)
    }
}
