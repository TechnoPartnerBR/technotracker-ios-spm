// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "IoTracker",
    platforms: [
        .iOS(.v14)
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
            url: "https://spm-sdk.technopartner.com.br/IoTracker/2.1.1/IoTracker.xcframework.zip",
            checksum: "db1afbebbce8a05ae24b7aec33543042ead1e721447eff6772c6f9ee8bf0db9c"
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
