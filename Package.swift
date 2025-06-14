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
        .package(url: "https://github.com/swiftlang/swift-docc-plugin.git", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.0"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", "509.0.0" ..< "601.0.0-prerelease")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ATProtoKit",
            dependencies: [
                "ATMacro",
                .product(name: "Logging", package: "swift-log")
            ]
//            plugins: ["VersionNumberPlugin"]
        ),

        // Macro implementation that performs the source transformations
        .macro(
            name: "Macros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "ATMacro",
            dependencies: [
                "Macros"
            ]
        )
//        .executableTarget(name: "VersionNumberPluginExec"),
//        .plugin(
//            name: "VersionNumberPlugin",
//            capability: .buildTool(),
//            dependencies: ["VersionNumberPluginExec"]
//        )

//        .testTarget(
//            name: "ATProtoKitTests",
//            dependencies: ["ATProtoKit"]),
    ]
)

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("StrictConcurrency"),
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableUpcomingFeature("GlobalActorIsolatedTypesUsability"),
    .enableUpcomingFeature("InferSendableFromCaptures"),
]

for target in package.targets {
    var settings = target.swiftSettings ?? []
    settings.append(contentsOf: swiftSettings)
    target.swiftSettings = settings
}
