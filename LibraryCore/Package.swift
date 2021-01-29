// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LibraryCore",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "LibraryCore",
            targets: ["LibraryCore"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/tadija/AEXML.git",
            .upToNextMajor(from: "4.6.0")
        ),
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.11.1"),
        .package(path: "/Users/kim.dung-pham/Development/the-stubborn-network")
//        .package(url: "http://github.com/q231950/the-stubborn-network.git",
//                 .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "LibraryCore",
            dependencies: ["XMLCoder", "AEXML", "StubbornNetwork"]),
        .testTarget(
            name: "LibraryCoreTests",
            dependencies: ["LibraryCore", "StubbornNetwork"]),
    ]
)
