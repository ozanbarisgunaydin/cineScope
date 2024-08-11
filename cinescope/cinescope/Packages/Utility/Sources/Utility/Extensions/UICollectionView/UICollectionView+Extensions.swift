//
//  UICollectionView+Extensions.swift
//
//
//  Created by Ozan Barış Günaydın on 9.08.2024.
//

import UIKit.UICollectionView

public extension UICollectionView {
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    
    func register<T: UICollectionViewCell>(
        nibWithCellClass name: T.Type,
        at bundle: Bundle? = nil
    ) {
        let identifier = String(describing: name)
        
        register(
            UINib(
                nibName: identifier,
                bundle: bundle
            ),
            forCellWithReuseIdentifier: identifier
        )
    }    
    
    func dequeueReusableCell<T: UICollectionViewCell>(
        withClass name: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError(
                """
                Couldn't find UICollectionViewCell for \(String(describing: name)),
                make sure the cell is registered with collection view
                """)
        }
        return cell
    }
    
    func registerReusableView<T: UICollectionReusableView>(nibWithViewClass name: T.Type, forSupplementaryViewOfKind kind: String, at bundle: Bundle? = nil) {
        let identifier = String(describing: name)
        
        register(
            UINib(nibName: identifier, bundle: bundle),
            forSupplementaryViewOfKind: kind,
            withReuseIdentifier: identifier
        )
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        withClass name: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: name),
            for: indexPath) as? T else {
            fatalError(
                """
                Couldn't find UICollectionReusableView for \(String(describing: name)),
                make sure the view is registered with collection view
                """)
        }
        return cell
    }
}
