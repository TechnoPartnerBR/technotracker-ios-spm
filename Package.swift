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
            url: "https://github.com/TechnoPartnerBR/RxBluetoothKit.git",
            exact: "6.0.0-ios15"
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
        .package(
            url: "https://github.com/emqx/CocoaMQTT.git",
            from: "2.1.0"
        ),
    ],
    targets: [
        .binaryTarget(
            name: "IoTracker",
            url: "https://spm-sdk.technopartner.com.br/IoTracker/2.1.5/IoTracker.xcframework.zip",
            checksum: "5125729b48806c2cd1c2183d3d15fc43c5d8ac40400bdb499477b82bbb091c02"
        ),
        .target(
            name: "IoTrackerDependencies",
            dependencies: [
                .product(name: "RxBluetoothKit", package: "RxBluetoothKit"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
                .product(name: "CocoaMQTT", package: "CocoaMQTT"),
            ],
            path: "Sources/IoTrackerDependencies"
        ),
    ]
)
