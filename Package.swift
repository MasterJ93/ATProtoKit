// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ATProtoKit",
    platforms: [
        .iOS(.v14),
        .macOS(.v13),
        .tvOS(.v14),
        .visionOS(.v1),
        .watchOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ATProtoKit",
            targets: ["ATProtoKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.7.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/MasterJ93/SwiftCBOR.git", from: "0.4.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ATProtoKit",
            dependencies: [
                "SwiftSoup",
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SwiftCBOR", package: "swiftcbor")
        ]
    )
//        .testTarget(
//            name: "ATProtoKitTests",
//            dependencies: ["ATProtoKit"]),
    ]
)
