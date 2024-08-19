//
//  Double+Extensions.swift
//
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import Foundation

extension Optional where Wrapped == Double {
    /// This extension rounds the Double value to one decimal place and returns a String
    /// If the value is nil, it returns "-".
    /// Example: 7.836 -> "7.8 ", nil -> "-"
    var roundedString: String {
        guard let value = self else {
            return "-"
        }
        let roundedValue = (value * 10).rounded() / 10
        return "\(roundedValue)"
    }
}
