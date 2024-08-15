//
//  MovieSimilarsView.swift
//
//
//  Created by Ozan Barış Günaydın on 15.08.2024.
//

import AppManagers
import Components
import UIKit
import Utility

// MARK: - MovieSimilarsView
final class MovieSimilarsView: UIView, NibOwnerLoadable {
    // MARK: - Typealias
    typealias Cell = SimilarMovieCellView
    
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var titleView: MovieSectionTitleView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyStateViewContainer: UIView!
    @IBOutlet private weak var emptyStateView: EmptyStateView!
    
    // MARK: - Data
    private var movies: [SimilarMovieContent] = [] {
        didSet {
            let isContentEmpty = movies.isEmpty
            emptyStateViewContainer.isHidden = !isContentEmpty
            collectionView.isHidden = isContentEmpty

            if !movies.isEmpty {
                collectionView.reloadData()
            }
        }
    }
    private var movieSelectionCallback: ((Int) -> Void)?
    
    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
    }
}

// MARK: - Publics
extension MovieSimilarsView {
    final func configureWith(
        movies: [SimilarMovieContent],
        movieSelectionCallback: ((Int) -> Void)?
    ) {
        self.movies = movies
        self.movieSelectionCallback = movieSelectionCallback
    }
}

// MARK: - Configuration
private extension MovieSimilarsView {
    final func setupViews() {
        configureContainerView()
        configureTitleView()
        configureCollectionView()
        configureEmptyView()
    }
    
    final func configureContainerView() {
        backgroundColor = .clear
        clipsToBounds = false
    }
    
    final func configureTitleView() {
        titleView.configureWith(title: L10nDetail.similars.localized())
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
        
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    final func configureEmptyView() {
        emptyStateView.configureWith(icon: .circleEmptyMovie)
        emptyStateView.isHidden = false
        
        emptyStateViewContainer.isHidden = true
        emptyStateViewContainer.cornerRadius = 12
        emptyStateViewContainer.borderColor = .separator
        emptyStateViewContainer.borderWidth = 4
        emptyStateViewContainer.backgroundColor = .white.withAlphaComponent(0.2)
    }
}


// MARK: - Helpers
private extension MovieSimilarsView {
    final func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            return createSection()
        }
        
        return layout
    }
    
    final func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Cell.cellSize.width),
            heightDimension: .absolute(Cell.cellSize.height)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(575),
            heightDimension: .estimated(Cell.cellSize.height)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(.spacingMedium)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(
            top: 0,
            leading: .paddingMedium,
            bottom: 0,
            trailing: .paddingMedium
        )
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = .spacingMedium
        
        return section
    }
}


// MARK: - UICollectionViewDataSource
extension MovieSimilarsView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withClass: Cell.self,
            for: indexPath
        )
        
        if let movie = movies[safe: indexPath.row] {
            cell.configureWith(
                imageURL: movie.imageURL,
                title: movie.name
            )
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieSimilarsView: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let movieSelectionCallback,
              let id = movies[safe: indexPath.row]?.id else { return }
        movieSelectionCallback(id)
    }
}

