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
}
