//
//  Double+Extensions.swift
//
//
//  Created by Ozan Barış Günaydın on 14.08.2024.
//

import Foundation

extension Optional where Wrapped == Double {
    /// This extension rounds the Double value to one decimal place
    /// and returns a String with "/ 10" appended.
    /// If the value is nil, it returns "- / 10".
    /// Example: 7.836 -> "7.8 / 10", nil -> "- / 10"
    var roundedStringWithSlashTen: String {
        guard let value = self else {
            return "- / 10"
        }
        let roundedValue = (value * 10).rounded() / 10
        return "\(roundedValue) / 10"
    }
}
