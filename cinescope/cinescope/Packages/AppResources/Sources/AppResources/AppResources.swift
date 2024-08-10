// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class AppResources {
    /// - `AppResources` shared instance
    public static var shared = AppResources()

    public static let bundle: Bundle = {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle(for: AppResources.self)
#endif
    }()
    
    // MARK: - Init
    private init() { }
}
