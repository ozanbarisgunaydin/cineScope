//
//  AppRoutes.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import Foundation

// MARK: - AppRoutes
public enum AppRoutes {
    case tabBar
    case listScreen
    case detail(id: Int)
    case safariController(url: String)
}
