//
//  FavoritesViewController.swift
//  
//
//  Created by Ozan Barış Günaydın on 20.08.2024.
//

import AppResources
import Components
import UIKit

// MARK: - FavoritesViewProtocol
protocol FavoritesViewProtocol: AnyObject  {
    var presenter: FavoritesPresenterProtocol? { get set }
}

// MARK: - FavoritesViewController
final class FavoritesViewController: BaseViewController, FavoritesViewProtocol {
    // MARK: - Typealias
    private typealias Cell = FavoriteMovieCellView
    
    // MARK: - Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyStateViewContainer: UIView!
    @IBOutlet private weak var emptyStateView: EmptyStateView!
    
    // MARK: - Components
    var presenter: FavoritesPresenterProtocol? {
        get { return basePresenter as? FavoritesPresenterProtocol }
        set { basePresenter = newValue }
    }
    
    // MARK: - Data
    var dataSource: UICollectionViewDiffableDataSource<FavoritesSectionType, AnyHashable>?
    
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
        observeFavoritesContent()
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
private extension FavoritesViewController {
    final func observeFavoritesContent() {
        presenter?.contentPublisher
            .sink { [weak self] content in
                guard let self,
                      !content.isEmpty else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Duration.animation) { [weak self] in
                    guard let self else { return }
                    applySnapshot(with: content)
                }
                
            }
            .store(in: &cancellables)
    }
}

// MARK: - Interface Configuration
private extension FavoritesViewController {
    final func configureNavigationBar() {
        shouldShowBackButton = false
        title = L10nFavorites.title.localized()
    }
    
    final func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.delegate = self
        
        collectionView.register(
            nibWithCellClass: Cell.self,
            at: Bundle.module
        )
        
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = .init(
            top: .spacingLarge,
            left: 0,
            bottom: .spacingLarge + self.safeAreaBottomHeight,
            right: 0
        )
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        configureDataSource()
    }
    
    final func configureEmptyView() {
        emptyStateView.configureWith(
            icon: .circleEmptyMovie,
            title: L10nFavoritesEmpty.title.localized(),
            message: L10nFavoritesEmpty.message.localized()
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
extension FavoritesViewController {
    final func applySnapshot(with data: [FavoritesContent]) {
        let isContentFilled = !(data.first?.items ?? []).isEmpty
        emptyStateViewContainer.isHidden = isContentFilled
        collectionView.isHidden = !isContentFilled
        
        guard isContentFilled else { return }
        var snapshot = NSDiffableDataSourceSnapshot<FavoritesSectionType, AnyHashable>()
        
        snapshot.appendSections(data.map { $0.sectionType })
        
        data.forEach { content in
            snapshot.appendItems(content.items, toSection: content.sectionType)
        }
        
        dataSource?.apply(snapshot)
    }
    
    final func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<FavoritesSectionType, AnyHashable>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            guard
                let item = item as? FavoritesItemType
            else {
                return UICollectionViewCell()
            }
            switch item {
            case .movie(let content):
                let movieCell = collectionView.dequeueReusableCell(
                    withClass: Cell.self,
                    for: indexPath
                )
                movieCell.configureWith(content: content)
                return movieCell
            }
        }
    }
}

// MARK: - Compositional Layout
private extension FavoritesViewController {
  final func createLayout() -> UICollectionViewLayout {
      var config = UICollectionLayoutListConfiguration(appearance: .plain)
      config.trailingSwipeActionsConfigurationProvider = { indexPath in
          let remveFromFavoriteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, completionHandler in
              guard let self else { return }
              
              presenter?.removeFromFavorites(on: indexPath.row)
          }
          remveFromFavoriteAction.image = .iconUnfavorited
          return UISwipeActionsConfiguration(actions: [remveFromFavoriteAction])
      }
            
      let layout = UICollectionViewCompositionalLayout.list(using: config)

      return layout
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        presenter?.routeToDetail(for: indexPath.row)
    }
}

