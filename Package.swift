// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Puma",
    platforms: [.macOS("10.15")],
    products: [
        .library(name: "Puma", targets: ["Puma"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/onmyway133/Spek.git",
            .upToNextMajor(from: "0.4.0")
        ),
        .package(
            url: "https://github.com/thii/xcbeautify.git",
            .upToNextMajor(from: "0.4.1")
        ),
        .package(
            url: "https://github.com/getGuaka/Colorizer",
            .upToNextMajor(from: "0.2.0")
        ),
        .package(
            url: "https://github.com/JohnSundell/Files.git",
            .upToNextMajor(from : "3.1.0")
        ),
        .package(
            url: "https://github.com/ChargePoint/xcparse",
            .upToNextMajor(from : "2.1.0")
        ),
        .package(
            url: "https://github.com/kiliankoe/CLISpinner",
            .upToNextMajor(from : "0.4.0")
        )
    ],
    targets: [
        .target(
            name: "Puma",
            dependencies: [
                "PumaiOS",
                "PumaAndroid",
            ],
            path: "Sources/Puma"
        ),
        .target(
            name: "PumaCore",
            dependencies: [
                "Colorizer",
                "Files",
                "CLISpinner"
            ],
            path: "Sources/Core"
        ),
        .target(
            name: "PumaiOS",
            dependencies: [
                "PumaCore",
                "XcbeautifyLib",
                "XCParseCore",
                "CLISpinner"
            ],
            path: "Sources/iOS"
        ),
        .target(
            name: "PumaAndroid",
            dependencies: [
                "PumaCore"
            ],
            path: "Sources/Android"
        ),
        .testTarget(
            name: "PumaTests",
            dependencies: [
                "Puma",
                "Spek"
            ]
        )
    ]
)
