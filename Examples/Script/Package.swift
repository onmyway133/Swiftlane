// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Script",
    platforms: [
        .macOS("12.0")
    ],
    products: [
        .executable(name: "Script", targets: ["Script"]),
    ],
    dependencies: [
        .package(path: "../.."),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "Script",
            dependencies: [
                .product(name: "Swiftlane", package: "swiftlane")
            ]
        ),
        .testTarget(
            name: "ScriptTests",
            dependencies: ["Script"]),
    ]
)
