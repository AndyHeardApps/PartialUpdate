// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "PartialUpdate",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "PartialUpdate",
            targets: ["PartialUpdate"]
        ),
        .executable(
            name: "PartialUpdateClient",
            targets: ["PartialUpdateClient"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
    ],
    targets: [
        .macro(
            name: "PartialUpdateMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "PartialUpdate", dependencies: ["PartialUpdateMacros"]),
        .executableTarget(name: "PartialUpdateClient", dependencies: ["PartialUpdate"]),
        .testTarget(
            name: "PartialUpdateTests",
            dependencies: [
                "PartialUpdateMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        )
    ]
)
