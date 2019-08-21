// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ManualCompile",
    dependencies: [
        .package(
            url: "https://github.com/pumaSwift/Puma.git",
            .upToNextMajor(from: "0.0.1")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "ManualCompile",
            dependencies: [
                "Puma"
            ]
        ),
        .testTarget(
            name: "ManualCompileTests",
            dependencies: ["ManualCompile"]),
    ]
)
