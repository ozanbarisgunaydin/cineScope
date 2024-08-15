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
    @IBOutlet private weak var scrollViewTopPadding: NSLayoutConstraint!
    @IBOutlet private weak var headerView: MovieHeaderView!
    @IBOutlet private weak var linksView: MovieLinksView!
    @IBOutlet private weak var descriptionView: MovieDescriptionView!
    @IBOutlet private weak var genresView: MovieGenresView!
    @IBOutlet private weak var similarsView: MovieSimilarsView!
    
    // MARK: - Constants
    private let scrollCollapseLimit: CGFloat = .spacingMedium
    private let scrollHorizontalPadding: CGFloat = .spacingMedium
    private var scrollAnimationLength: CGFloat {
        return MovieHeaderView.expendedHeight - MovieHeaderView.collapsedHeight
    }

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
        observeHeader()
        observeLinks()
        observeOverview()
        observeGenres()
        observeSimilarMovies()
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
    final func observeHeader() {
        presenter?.headerPublisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] headerContent in
                guard let self,
                      let headerContent else { return }
                headerView.configureWith(content: headerContent)
            })
        .store(in: &cancellables)
    }
    
    final func observeLinks() {
        presenter?.linksPublisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] linksContent in
                guard let self,
                      let linksContent else { return }
                linksView.configureWith(content: linksContent) { [weak self] url in
                    guard let self else { return }
                    presenter?.routeToWeb(with: url)
                }
            })
        .store(in: &cancellables)
    }
    
    final func observeOverview() {
        presenter?.overviewPublisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] overviewContent in
                guard let self else { return }
                descriptionView.configureWith(overview: overviewContent)
            })
        .store(in: &cancellables)
    }
    
    final func observeGenres() {
        presenter?.genresPublisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] genres in
                guard let self,
                      let genres else { return }
                genresView.configureWith(genres: genres) { [weak self] genreID in
                    guard let self else { return }
                    presenter?.routeToGenre(with: genreID)
                }
            })
        .store(in: &cancellables)
    }
    
    final func observeSimilarMovies() {
        presenter?.similarMoviesPublisher.sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] similarMovies in
                guard let self,
                      let similarMovies else { return }
                similarsView.configureWith(movies: similarMovies) { [weak self] movieID in
                    guard let self else { return }
                    presenter?.routeToMovieDetail(with: movieID)
                }
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
        scrollViewTopPadding.constant = MovieHeaderView.collapsedHeight + .paddingLarge
        scrollView.delegate = self
        scrollView.contentInset.top = scrollAnimationLength
        scrollView.contentInset.bottom = self.safeAreaBottomHeight + scrollHorizontalPadding
    }
}


// MARK: - UIScrollViewDelegate
extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isScrollLimitReached = scrollView.contentOffset.y > scrollCollapseLimit - scrollAnimationLength
        headerView.changeImage(isCollapsedStage: isScrollLimitReached)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let scrollLength = scrollView.contentOffset.y
        guard scrollLength > scrollCollapseLimit - scrollAnimationLength,
              scrollLength < scrollCollapseLimit else { return }
        scrollView.setContentOffset(
            CGPoint(
                x: 0,
                y: 0
            ),
            animated: true
        )
    }
}
