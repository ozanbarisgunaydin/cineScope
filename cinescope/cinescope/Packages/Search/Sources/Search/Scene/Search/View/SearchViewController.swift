//
//  SearchViewController.swift
//  
//
//  Created by Ozan Barış Günaydın on 16.08.2024.
//

import AppResources
import Components
import UIKit

// MARK: - DetailViewProtocol
protocol SearchViewProtocol: AnyObject  {
    var presenter: SearchPresenterProtocol? { get set }
}

// MARK: - SearchViewController
final class SearchViewController: BaseViewController, SearchViewProtocol {
    // MARK: - Typealias
    private typealias Cell = MovieListCellView
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyStateViewContainer: UIView!
    @IBOutlet private weak var emptyStateView: EmptyStateView!

    // MARK: - Components
    var presenter: SearchPresenterProtocol? {
        get { return basePresenter as? SearchPresenterProtocol }
        set { basePresenter = newValue }
    }
    
    // MARK: - Data
    var dataSource: UICollectionViewDiffableDataSource<SearchSectionType, AnyHashable>?

    // MARK: - Life Cycles
    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchContent()
    }
    
    // MARK: - Interface Configuration
    override func configureInterface() {
        super.configureInterface()
        configureNavigationBar()
        configureCollectionView()
        configureEmptyView()
    }
    
    // MARK: - Observe
    override func observeContent() {
        super.observeContent()
        observeCollectionContent()
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
private extension SearchViewController {
    final func observeCollectionContent() {
        presenter?.contentPublisher
            .sink { [weak self] content in
                guard let self,
                      !content.isEmpty else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    applySnapshot(with: content)
                }
                
            }
            .store(in: &cancellables)
    }
}

// MARK: - Interface Configuration
private extension SearchViewController {
    final func configureNavigationBar() {
        title = presenter?.contentTitle
        view.backgroundColor = .backgroundPrimary
    }
    
    final func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        
        collectionView.register(
            nibWithCellClass: Cell.self,
            at: Bundle.module
        )
        
        collectionView.backgroundColor = .backgroundPrimary
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        configureDataSource()
    }
    
    final func configureEmptyView() {
        emptyStateView.configureWith(
            icon: .circleEmptyMovie,
            title: L10nSearchEmpty.title.localized(),
            message: L10nSearchEmpty.message.localized()
        )
        emptyStateView.isHidden = false
        
        emptyStateViewContainer.isHidden = true
        emptyStateViewContainer.cornerRadius = 12
        emptyStateViewContainer.borderColor = .separator
        emptyStateViewContainer.borderWidth = 4
        emptyStateViewContainer.backgroundColor = .white.withAlphaComponent(0.2)
    }
}


// MARK: - Diffable Data Source
extension SearchViewController {
    final func applySnapshot(with data: [SearchContent]) {
        let isContentFilled = !(data.first?.items ?? []).isEmpty
        emptyStateViewContainer.isHidden = isContentFilled
        collectionView.isHidden = !isContentFilled
        
        guard isContentFilled else { return }
        var snapshot = NSDiffableDataSourceSnapshot<SearchSectionType, AnyHashable>()
        
        snapshot.appendSections(data.map { $0.sectionType })
        
        data.forEach { content in
            snapshot.appendItems(content.items, toSection: content.sectionType)
        }
        
        dataSource?.apply(snapshot)
    }
    
    final func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SearchSectionType, AnyHashable>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            guard
                let item = item as? SearchItemType
            else {
                return UICollectionViewCell()
            }
            switch item {
            case .movie(let content):
                let movieCell = collectionView.dequeueReusableCell(
                    withClass: Cell.self,
                    for: indexPath
                )
                movieCell.configureWith(
                    title: content.title,
                    posterURL: content.posterURL,
                    year: content.year,
                    vote: content.vote
                )
                return movieCell
            }
        }
    }
}

// MARK: - Compositional Layout
private extension SearchViewController {
    final func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            return createSection()
        }
        
        return layout
    }
    
    final func createSection() -> NSCollectionLayoutSection {
        let width = (.screenWidth - (.spacingLarge * 4)) / 3
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(width * Cell.widthToHeightRatio)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(.spacingLarge)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: .spacingLarge,
            leading: 0,
            bottom: .spacingLarge + self.safeAreaBottomHeight,
            trailing: 0
        )
        section.interGroupSpacing = .spacingLarge
        
        return section
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presenter?.routeToDetail(for: indexPath.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard indexPath.row == presenter?.lastIndex else { return }
        presenter?.fetchContent()
    }
}
