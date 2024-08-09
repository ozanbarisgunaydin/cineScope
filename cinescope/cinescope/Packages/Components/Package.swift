// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Components",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Components",
            targets: ["Components"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-spm.git", .upToNextMajor(from: "4.5.0")),
        .package(url: "https://github.com/slackhq/PanModal.git", .upToNextMajor(from: "1.2.6")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", .upToNextMajor(from: "7.0.1")),
        .package(path: "../AppResources"),
        .package(path: "../Network"),
        .package(path: "../Utility")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Components",
            dependencies: [
                .product(name: "Lottie", package: "lottie-spm"),
                "PanModal",
                "Kingfisher",
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
                "AppResources",
                "Network",
                "Utility"
            ]
        ),
        .testTarget(
            name: "ComponentsTests",
            dependencies: ["Components"]
        )
    ]
)
