//
//  String+Date.swift
//
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import Foundation

public extension String {
    /// Converts a date string from the format "yyyy-MM-dd" to "MM.dd.yyyy" and returns the year of date..
    ///
    /// This method takes a string representing a date in the "yyyy-MM-dd" format, converts it to a `Date` object, and then formats it into a string in the "MM.dd.yyyy" format and returns the year component as String..
    ///
    /// - Returns: Year's string in the "MM.dd.yyyy" format if the conversion is successful, otherwise `nil`.
    ///
    /// - Example:
    ///   ```swift
    ///   let originalDate = "2024-07-24"
    ///   if let formattedDate = originalDate.yearComponent {
    ///       print(formattedDate) // Output: "2024"
    ///   }
    ///   ```
    var yearComponent: String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM.dd.yyyy"
        
        if let date = inputFormatter.date(from: self) {
            return "\(outputFormatter.calendar.component(.year, from: date))"
        } else {
            return nil
        }
    }
}
