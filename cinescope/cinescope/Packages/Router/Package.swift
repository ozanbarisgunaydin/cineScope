// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Router",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Router",
            targets: ["Router"]
        )
    ],
    dependencies: [
        .package(path: "../Components"),
        .package(path: "../Splash"),
        .package(path: "../Home"),
        .package(path: "../TabBar"),
        .package(path: "../Detail"),
        .package(path: "../Search")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Router",
            dependencies: [
                "Components",
                "Splash",
                "Home",
                "TabBar",
                "Detail",
                "Search"
            ]
        ),
        .testTarget(
            name: "RouterTests",
            dependencies: ["Router"]
        )
    ]
)
