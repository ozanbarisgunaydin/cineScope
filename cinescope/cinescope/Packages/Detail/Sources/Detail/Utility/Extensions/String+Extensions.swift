//
//  String+Extensions.swift
//
//
//  Created by Ozan Barış Günaydın on 13.08.2024.
//

import Foundation

extension String {
    /// Converts a date string from the format "yyyy-MM-dd" to "MM.dd.yyyy".
    ///
    /// This method takes a string representing a date in the "yyyy-MM-dd" format, converts it to a `Date` object, and then formats it into a string in the "MM.dd.yyyy" format.
    ///
    /// - Returns: A string in the "MM.dd.yyyy" format if the conversion is successful, otherwise `nil`.
    ///
    /// - Example:
    ///   ```swift
    ///   let originalDate = "2024-07-24"
    ///   if let formattedDate = originalDate.convertDateFormat() {
    ///       print(formattedDate) // Output: "07.24.2024"
    ///   }
    ///   ```
    func convertDateFormat() -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM.dd.yyyy"
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}

extension Optional where Wrapped == String {
    /// This extension converts an optional IMDB ID string into a full IMDB URL string.
    /// If the value is nil or empty, it returns the IMDB home page URL.
    /// Example: "tt6263850" -> "https://www.imdb.com/title/tt6263850/"
    /// Example: nil or "" -> "https://www.imdb.com/"
    var imdbURL: String {
        let imdbBaseURL = "https://www.imdb.com/"
        guard let id = self, !id.isEmpty else {
            return imdbBaseURL
        }
        return "\(imdbBaseURL)title/\(id)/"
    }
}
