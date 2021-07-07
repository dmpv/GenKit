// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GenKit",
    products: [
        .executable(name: "genkit-cli", targets: ["genkit-cli"]),
        .library(name: "GenKit", targets: ["GenKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.4.3"),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.3.0"),
    ],
    targets: [
        .target(
            name: "genkit-cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "ShellOut"
            ]
        ),
        .target(
            name: "GenKit",
            dependencies: []
        ),
        .testTarget(
            name: "GenKitTests",
            dependencies: ["GenKit"]),
    ]
)
