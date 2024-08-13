//
//  Int+Extensions.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import Foundation

extension Int {
    /// Converts an integer to a U.S. dollar currency string with a maximum 3-character abbreviation.
    ///
    /// This method formats the integer as a currency string in U.S. dollars, abbreviating large numbers with "K" for thousands, "Mn" for millions, and "Bn" for billions.
    ///
    /// - Returns: A string representing the integer in U.S. dollar currency format with an abbreviation.
    ///
    /// - Example:
    ///   ```swift
    ///   let amount = 20000000
    ///   let formattedAmount = amount.toAbbreviatedDollarCurrency()
    ///   print(formattedAmount) // Output: "$20 Mn"
    ///   ```
    func toAbbreviatedDollarCurrency() -> String {
        let sign = self < 0 ? "-" : ""
        let absValue = abs(self)
        
        switch absValue {
        case 1_000_000_000...:
            return "\(sign)$\(absValue / 1_000_000_000) Bn"
        case 1_000_000...:
            return "\(sign)$\(absValue / 1_000_000) Mn"
        case 1_000...:
            return "\(sign)$\(absValue / 1_000) Th"
        default:
            return "\(sign)$\(absValue)"
        }
    }
}
