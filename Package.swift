// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Swiftlane",
    platforms: [
        .macOS("12.0")
    ],
    products: [
        .library(name: "Swiftlane", targets: ["Swiftlane"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/tuist/xcbeautify",
            .upToNextMajor(from: "0.11.0")
        ),
        .package(
            url: "https://github.com/onevcat/Rainbow",
            .upToNextMajor(from: "4.0.1")
        ),
        .package(
            url: "https://github.com/JohnSundell/Files.git",
            .upToNextMajor(from : "4.2.0")
        ),
        .package(
            url: "https://github.com/ChargePoint/xcparse",
            .upToNextMajor(from : "2.2.1")
        ),
        .package(
            url: "https://github.com/yahoojapan/SwiftyXMLParser",
            .upToNextMajor(from: "5.6.0")
        ),
        .package(
            url: "https://github.com/onmyway133/AppStoreConnect",
            .upToNextMajor(from: "0.0.8")
        )
    ],
    targets: [
        .target(
            name: "Swiftlane",
            dependencies: [
                .product(name: "XCParseCore", package: "xcparse"),
                .product(name: "XcbeautifyLib", package: "xcbeautify"),
                "Files",
                "Rainbow",
                "AppStoreConnect",
                "SwiftyXMLParser"
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "SwiftlaneTests",
            dependencies: [
                "Swiftlane"
            ]
        )
    ]
)
