//
//  SearchTabViewController.swift
//  
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import Components
import UIKit

// MARK: - DetailViewProtocol
protocol SearchTabViewProtocol: AnyObject  {
    var presenter: SearchTabPresenterProtocol? { get set }
}

// MARK: - SearchTabViewController
final class SearchTabViewController: BaseViewController, SearchTabViewProtocol {
    // MARK: - Typealias
    typealias Cell = SearchKeywordCellView
    // MARK: - Outlets
    @IBOutlet private weak var searchBackgroundView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Components
    var presenter: SearchTabPresenterProtocol? {
        get { return basePresenter as? SearchTabPresenterProtocol }
        set { basePresenter = newValue }
    }

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchContent()
    }
    
    // MARK: - Interface Configuration
    override func configureInterface() {
        super.configureInterface()
        configureNavigationBar()
        configureContainerView()
        configureSearchBar()
        configureCollectionView()
    }
    
    // MARK: - Observe
    override func observeContent() {
        super.observeContent()
        observeKeywordNotifier()
    }
    
    // MARK: - Init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SearchTabViewController {
    final func observeKeywordNotifier() {
        presenter?.keywordNotifier
            .sink { _ in } receiveValue: { [weak self] _ in
                guard let self else { return }
                collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Interface Configuration
private extension SearchTabViewController {
    final func configureNavigationBar() {
        shouldShowNavigationBar = false
    }
    
    final func configureContainerView() {
        view.backgroundColor = .black
        view.setGradientBackground(
            colors: [
                .black.withAlphaComponent(0.7),
                .darkGray.withAlphaComponent(0.2),
                .lightGray.withAlphaComponent(0.3)
            ],
            locations: [0, 0.5, 1]
        )
    }
    
    final func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = L10nSearch.searchPlaceholder.localized()
        
        searchBackgroundView.backgroundColor = .primaryColor
        searchBar.barTintColor = .primaryColor
        searchBar.searchTextField.textColor = .white
    }
    
    final func configureCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = createLayout()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            nibWithCellClass: Cell.self,
            at: Bundle.module
        )
        
        collectionView.contentInset = .init(
            top: .paddingLarge,
            left: .spacingLarge,
            bottom: .paddingLarge,
            right: -.spacingLarge
        )
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
}

// MARK: - Interface Configuration
extension SearchTabViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text,
              !keyword.isEmpty else { return }
        presenter?.routeToSearch(with: keyword)
    }
}


// MARK: - Helpers
private extension SearchTabViewController {
    final func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            return createGenreSection()
        }
        
        return layout
    }
    
    final func createGenreSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(Cell.cellHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Cell.cellHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(.spacingMedium)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = .spacingMedium
        
        return section
    }
}


// MARK: - UICollectionViewDataSource
extension SearchTabViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getKeywordsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withClass: Cell.self,
            for: indexPath
        )
        
        if let keyword = presenter?.getKeyword(for: indexPath.row) {
            cell.configureWith(keyword: keyword)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SearchTabViewController: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presenter?.routeToSearch(on: indexPath.row)
    }
}
