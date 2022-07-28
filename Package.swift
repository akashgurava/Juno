// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of
// Swift required to build this package.

import PackageDescription

// swift-format-ignore
// swiftlint: disable prefixed_toplevel_constant missing_docs explicit_top_level_acl
let package = Package(
    name: "Juno",
    platforms: [
        .iOS(.v14),
        .watchOS(.v6),
        .tvOS(.v11),
        .macOS(.v11),
    ],
    products: [
        // Products define the executables and libraries a package produces,
        // and make them visible to other packages.
        .library(
            name: "Juno",
            targets: ["Juno"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "1.0.2")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package.
        // A target can define a module or a test suite.
        // Targets can depend on other targets in this package,
        // and on products in packages this package depends on.
        .target(
            name: "Juno",
            dependencies: [
                .product(name: "OrderedCollections", package: "swift-collections"),
            ]
        ),
        .testTarget(
            name: "JunoTests",
            dependencies: ["Juno"]
        ),
    ]
)
