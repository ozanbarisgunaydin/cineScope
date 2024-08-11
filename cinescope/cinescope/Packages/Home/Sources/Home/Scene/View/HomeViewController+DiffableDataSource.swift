//
//  HomeViewController+DiffableDataSource.swift
//
//
//  Created by Ozan Barış Günaydın on 10.08.2024.
//

import UIKit

// MARK: - Diffable Data Source
extension HomeViewController {
    final func applySnapshot(with data: [HomeContent]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSectionType, AnyHashable>()

        snapshot.appendSections(data.map { $0.sectionType })

        data.forEach { content in
            snapshot.appendItems(content.items, toSection: content.sectionType)
        }

        dataSource?.apply(snapshot)
    }

    final func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<HomeSectionType, AnyHashable>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in
            guard 
                let item = item as? HomeItemType
            else {
                return UICollectionViewCell()
            }
            switch item {
            case .genre(let content):
                let marketCell = collectionView.dequeueReusableCell(
                    withClass: GenreCell.self,
                    for: indexPath
                )
                marketCell.configureWith(content: content)
                return marketCell

            case .category(let content):
                let gameUniverseCell = collectionView.dequeueReusableCell(
                    withClass: CategoryCell.self,
                    for: indexPath
                )
                gameUniverseCell.configureWith(type: content)
                return gameUniverseCell

            case .person(let content):
                let populerMatchCell = collectionView.dequeueReusableCell(
                    withClass: PersonCell.self,
                    for: indexPath
                )
                populerMatchCell.configureWith(content: content)
                return populerMatchCell
            }
        }

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard
                kind == UICollectionView.elementKindSectionHeader,
                let section = self.dataSource?.snapshot().sectionIdentifiers[safe: indexPath.section]
            else {
                return UICollectionReusableView()
            }

            switch section {
            case .genreList(let content):
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withClass: GenreHeader.self,
                    for: indexPath
                )
                headerView.configureWith(title: content) { [weak self] in
                    guard let self else { return }
                    // TODO: - Live Bet Header selection can handled with this block.
                    print("Genre selected on \(self)")
                }
                return headerView

            case .categories(let title),
                 .reviews(let title):
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withClass: TitleHeader.self,
                    for: indexPath
                )
                headerView.configureWith(title: title)
                return headerView
            }
        }
    }
}
