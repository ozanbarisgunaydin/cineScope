//
//  MovieCompaniesView.swift
//
//
//  Created by Ozan Barış Günaydın on 16.08.2024.
//

import AppManagers
import Components
import UIKit
import Utility

// MARK: - MovieCompaniesView
final class MovieCompaniesView: UIView, NibOwnerLoadable {
    // MARK: - Typealias
    typealias Cell = CompanyCellView
    
    // MARK: - Module
    public static var module = Bundle.module
    
    // MARK: - UI Components
    @IBOutlet private weak var titleView: MovieSectionTitleView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionHeight: NSLayoutConstraint!
    
    // MARK: - Data
    private var companies: [MovieCompanyContent] = [] {
        didSet {
            collectionView.reloadData { [weak self] in
                guard let self else { return }
                collectionHeight.constant = collectionView.contentSize.height
            }
        }
    }
    private var companySelectionCallback: ((Int) -> Void)?
    
    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
    }
}

// MARK: - Publics
extension MovieCompaniesView {
    final func configureWith(
        companies: [MovieCompanyContent],
        companySelectionCallback: ((Int) -> Void)?
    ) {
        self.companies = companies
        self.companySelectionCallback = companySelectionCallback
    }
}

// MARK: - Configuration
private extension MovieCompaniesView {
    final func setupViews() {
        configureContainerView()
        configureTitleView()
        configureCollectionView()
    }
    
    final func configureContainerView() {
        backgroundColor = .clear
    }
    
    final func configureTitleView() {
        titleView.configureWith(title: L10nDetail.companaies.localized())
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
private extension MovieCompaniesView {
    final func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {[weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            return createSection()
        }
        
        return layout
    }
    
    final func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(60),
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
extension MovieCompaniesView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return companies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withClass: Cell.self,
            for: indexPath
        )
        
        if let company = companies[safe: indexPath.row] {
            cell.configureWith(
                name: company.name,
                imageURL: company.imageURL
            )
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MovieCompaniesView: UICollectionViewDelegate {
    public func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let companySelectionCallback,
              let id = companies[safe: indexPath.row]?.id else { return }
        companySelectionCallback(id)
    }
}

