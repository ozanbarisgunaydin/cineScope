//
//  HomeViewController+CompositionalLayout.swift
//
//
//  Created by Ozan Barış Günaydın on 10.08.2024.
//

import AppResources
import Utility
import UIKit

// MARK: - Compositonal Layout
extension HomeViewController {
    final func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self,
                  let sectionProperties = presenter?.getSectionProperties(for: sectionIndex) else { return nil }
            return createSection(
                for: sectionProperties.type,
                on: sectionProperties.itemCount
            )
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = .paddingLarge
        layout.configuration = config

        return layout
    }

    final func createSection(
        for type: HomeSectionType,
        on itemCount: Int
    ) -> NSCollectionLayoutSection {
        switch type {
        case .genreList:
            return createGenreListSection(for: itemCount)
        case .categories:
            return createCategoriesSection()
        case .celebrities:
            return createPersonsSection()
        }
    }
    
    final func createGenreListSection(for itemCount: Int) -> NSCollectionLayoutSection {
        let headerWidth = GenreHeader.viewSize.width
        let headerHeight = GenreHeader.viewSize.height
        let itemPadding: CGFloat = 6
        let headerOffset = headerWidth

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .absolute(headerWidth),
            heightDimension: .absolute(headerHeight)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        header.extendsBoundary = false
        header.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: -headerOffset,
            bottom: 0,
            trailing: headerOffset
        )

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(64),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let innerGroupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(64),
            heightDimension: .absolute((headerHeight - itemPadding) / 2)
        )
        var countedItems: [NSCollectionLayoutItem] = []
        let layoutNeededCount = Int((itemCount.double / 2).rounded(.up))
        for _ in 0..<layoutNeededCount { countedItems.append(item) }
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: innerGroupSize,
            subitems: countedItems
        )
        group.interItemSpacing = .fixed(itemPadding)

        let nestedGroupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(64),
            heightDimension: .absolute(headerHeight)
        )
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: nestedGroupSize,
            subitems: [group, group]
        )
        nestedGroup.interItemSpacing = .fixed(itemPadding)

        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: headerOffset,
            bottom: 0,
            trailing: .spacingLarge
        )
        section.orthogonalScrollingBehavior = .continuous
        return section
    }

    final func createCategoriesSection() -> NSCollectionLayoutSection {
        let width = (.screenWidth - (.spacingLarge * 3)) / 2
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(width * CategoryCell.widthToHeightRatio)
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
        section.boundarySupplementaryItems = [getTitleHeaderItem()]
        section.contentInsets = getSectionInsets()
        section.interGroupSpacing = .spacingLarge

        return section
    }

    final func createPersonsSection() -> NSCollectionLayoutSection {
        let wantedItemSize = PersonCell.viewSize
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(wantedItemSize.width),
            heightDimension: .absolute(wantedItemSize.height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(300),
            heightDimension: .estimated(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [getTitleHeaderItem()]
        section.contentInsets = getSectionInsets()
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = .spacingLarge

        return section
    }

    final func getSectionInsets() -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(
            top: 0,
            leading: .spacingLarge,
            bottom: 0,
            trailing: .spacingLarge
        )
    }

    final func getTitleHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(18)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        header.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: .paddingMedium,
            trailing: 0
        )

        return header
    }
}
