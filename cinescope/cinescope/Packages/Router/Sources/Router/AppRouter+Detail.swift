//
//  AppRouter+Detail.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import Detail
import Foundation

extension AppRouter {
    public func routeToDetail(with id: Int) {
        let detailRouter = DetailRouter(
            delegate: self,
            movieID: id,
            navigationController
        )
        detailRouter.createModule()
    }
}


