//
//  SearchViewController.swift
//  
//
//  Created by Ozan Barış Günaydın on 16.08.2024.
//

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

    // MARK: - Constants

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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
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
        title = "Search"
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
}


// MARK: - Diffable Data Source
extension SearchViewController {
    final func applySnapshot(with data: [SearchContent]) {
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
                let marketCell = collectionView.dequeueReusableCell(
                    withClass: Cell.self,
                    for: indexPath
                )
                marketCell.configureWith(
                    title: content.title,
                    posterURL: content.posterURL,
                    year: content.year,
                    vote: content.vote
                )
                return marketCell
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
            leading: .spacingLarge,
            bottom: .spacingLarge,
            trailing: .spacingLarge
        )
        section.interGroupSpacing = .spacingLarge
        
        return section
    }
}

// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}
