//
//  AppRouter+Search.swift
//
//
//  Created by Ozan Barış Günaydın on 17.08.2024.
//

import Components
import Foundation
import Search

extension AppRouter {
    public func routeToSearch(with type: SearchType) {
        let searchRouter = SearchRouter(
            delegate: self,
            searchType: type,
            navigationController
        )
        searchRouter.createModule()
    }
}
