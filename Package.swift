// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

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
        .library(
            name: "ATMacro",
            targets: ["ATMacro"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.7.0"),
        .package(url: "https://github.com/swiftlang/swift-docc-plugin.git", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/MasterJ93/SwiftCBOR.git", from: "0.4.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "510.0.3")
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
        ),

        // Macro implementation that performs the source transformations
        .macro(
            name: "ATUnionMacro",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "ATMacro",
            dependencies: [
                "ATUnionMacro"
            ]
        )

//        .testTarget(
//            name: "ATProtoKitTests",
//            dependencies: ["ATProtoKit"]),
    ]
)
