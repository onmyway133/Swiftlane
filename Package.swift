// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Puma",
    platforms: [.macOS("10.15")],
    products: [
        .executable(name: "PumaRunner", targets: ["PumaRunner"]),
        .library(name: "Puma", targets: ["Puma"])
    ],
    dependencies: [
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
        )
    ],
    targets: [
        .target(
            name: "PumaRunner",
            dependencies: [
                "Puma"
            ]
        ),
        .target(
            name: "Puma",
            dependencies: [
                "XcbeautifyLib",
                "Colorizer",
                "Files"
            ]
        ),
        .testTarget(
            name: "PumaTests",
            dependencies: ["Puma"
            ]
        )
    ]
)
