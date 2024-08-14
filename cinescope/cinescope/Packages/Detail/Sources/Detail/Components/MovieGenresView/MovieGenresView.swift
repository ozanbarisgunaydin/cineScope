//
//  MovieGenresView.swift
//
//
//  Created by Ozan Barış Günaydın on 14.08.2024.
//

import AppManagers
import Components
import UIKit
import Utility

// MARK: - MovieGenresView
final class MovieGenresView: UIView, NibOwnerLoadable {
    // MARK: - Typealias
    typealias Cell = DetailGenreCellView

    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var titleView: MovieSectionTitleView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionHeight: NSLayoutConstraint!
    
    // MARK: - Data
    private var genres: [Genre] = [] {
        didSet {
            collectionView.reloadData { [weak self] in
                guard let self else { return }
                collectionHeight.constant = collectionView.contentSize.height
            }
        }
    }
    private var genreSelectionCallback: ((Int) -> Void)?
    
    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
    }
}

// MARK: - Publics
extension MovieGenresView {
    final func configureWith(
        genres: [Genre],
        genreSelectionCallback: ((Int) -> Void)?
    ) {
        self.genres = genres
        self.genreSelectionCallback = genreSelectionCallback
    }
}

// MARK: - Configuration
private extension MovieGenresView {
    final func setupViews() {
        configureContainerView()
        configureTitleView()
        configureCollectionView()
    }
    
    final func configureContainerView() {
        backgroundColor = .clear
    }
    
    final func configureTitleView() {
        titleView.configureWith(title: L10nDetail.genres.localized())
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
}


// MARK: - Helpers
private extension MovieGenresView {
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
extension MovieGenresView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withClass: Cell.self,
            for: indexPath
        )
        
        if let title = genres[safe: indexPath.row]?.name {
            cell.configureWith(genreTitle: title)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieGenresView: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let genreSelectionCallback,
              let id = genres[safe: indexPath.row]?.id else { return }
        genreSelectionCallback(id)
    }
}

