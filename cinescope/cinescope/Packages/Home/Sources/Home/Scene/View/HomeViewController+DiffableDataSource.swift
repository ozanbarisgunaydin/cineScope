//
//  HomeViewController+DiffableDataSource.swift
//
//
//  Created by Ozan Barış Günaydın on 10.08.2024.
//

import AppResources
import UIKit

// MARK: - Diffable Data Source
extension HomeViewController {
    final func applySnapshot(with data: [HomeContent]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSectionType, AnyHashable>()

        snapshot.appendSections(data.map { $0.sectionType })

        data.forEach { content in
            snapshot.appendItems(content.items, toSection: content.sectionType)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Duration.animation) { [weak self] in
            guard let self else { return }
            dataSource?.apply(snapshot)
        }
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
                let genreCell = collectionView.dequeueReusableCell(
                    withClass: GenreCell.self,
                    for: indexPath
                )
                genreCell.configureWith(content: content)
                return genreCell

            case .category(let content):
                let categoryCell = collectionView.dequeueReusableCell(
                    withClass: CategoryCell.self,
                    for: indexPath
                )
                categoryCell.configureWith(type: content)
                return categoryCell

            case .person(let content):
                let personCell = collectionView.dequeueReusableCell(
                    withClass: PersonCell.self,
                    for: indexPath
                )
                personCell.configureWith(content: content)
                return personCell
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
                headerView.configureWith(title: content)
                return headerView

            case .categories(let title),
                 .celebrities(let title):
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
