//
//  Constants.swift
//
//
//  Created by Ozan Barış Günaydın on 12.12.2023.
//

import Foundation

public enum Constants {
    public enum Duration {
        /// 0.3
        public static let animation: Double = 0.3
        /// 3
        public static let toast: Double = 3
    }

    public enum DatePicker {
        /// -18
        public static let date: Int = -18
        /// -120
        public static let minDate: Int = -120
        /// -18
        public static let maxDate: Int = -18
        /// dd.MM.yyyy
        public static let dateFormat = "dd.MM.yyyy"
    }

    public enum TabBarIndex: Int {
        /// 0
        case home = 0
    }
}