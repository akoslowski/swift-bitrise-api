// swift-tools-version: 5.10

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
        .package(url: "https://github.com/akoslowski/simple-code-gen-support", from: "0.0.1"),
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
            name: "operation-renamer",
            dependencies: [
                .product(name: "CodeGenSupport", package: "simple-code-gen-support")
            ]
        ),
    ]
)
