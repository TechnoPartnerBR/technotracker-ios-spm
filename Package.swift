// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "IoTracker",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "IoTracker",
            targets: ["IoTracker", "IoTrackerDependencies"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/chamira-at/RxBluetoothKit.git",
            branch: "ios-15-support"
        ),
        .package(
            url: "https://github.com/krzyzanowskim/CryptoSwift.git",
            from: "1.7.2"
        ),
        .package(
            url: "https://github.com/evgenyneu/keychain-swift.git",
            from: "19.0.0"
        ),
        .package(
            url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git",
            from: "3.8.0"
        ),
    ],
    targets: [
        .binaryTarget(
            name: "IoTracker",
            url: "https://ios-sdk.technopartner.com.br/IoTracker/2.0.1/IoTracker.xcframework.zip",
            checksum: "b6c99aed90f65479b1fccee404959c8872dc2ddfb080817128c5ecfc483f0daf"
        ),
        .target(
            name: "IoTrackerDependencies",
            dependencies: [
                .product(name: "RxBluetoothKit", package: "RxBluetoothKit"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
            ],
            path: "Sources/IoTrackerDependencies"
        ),
    ]
)
