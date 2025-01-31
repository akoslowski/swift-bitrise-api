// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "swift-bitrise-api",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        .library(
            name: "BitriseAPI",
            targets: ["BitriseAPI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "BitriseAPI",
            dependencies: [
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ]
        ),
        .testTarget(
            name: "BitriseAPITests",
            dependencies: ["BitriseAPI"]
        ),
        .executableTarget(
            name: "renamer"
        ),
    ]
)
