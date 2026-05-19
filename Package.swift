// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let swiftSettings: [SwiftSetting] = [
    .enableExperimentalFeature("ExistentialAny"),
    .enableExperimentalFeature("StrictConcurrency")
]

let package = Package(
    name: "PartialUpdate",
    platforms: [
        .macOS(.v13),
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "PartialUpdate",
            targets: ["PartialUpdate"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            from: "603.0.1"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-macro-testing",
            from: "0.6.5"
        )
    ],
    targets: [
        .macro(
            name: "PartialUpdateMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "PartialUpdate",
            dependencies: [
                "PartialUpdateMacros"
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "PartialUpdateTests",
            dependencies: [
                "PartialUpdateMacros",
                "PartialUpdate",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "MacroTesting", package: "swift-macro-testing")
            ],
            swiftSettings: swiftSettings
        )
    ],
    swiftLanguageModes: [.v6]
)

