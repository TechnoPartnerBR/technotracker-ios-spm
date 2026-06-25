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
            targets: ["IoTracker"]
        ),
    ],
    // No package dependencies are declared for consumers: the IoTracker
    // XCFramework statically embeds all of its SPM dependencies
    // (RxBluetoothKit, RxSwift, CryptoSwift, KeychainSwift, CocoaLumberjack,
    // CocoaMQTT) into its binary and is fully self-contained (NOUNDEFS).
    // A previous shim target (IoTrackerDependencies) re-declared them so
    // consumers linked them again, which registered every Obj-C class twice
    // and produced "Class ... is implemented in both ..." warnings (TP-7555).
    // The build script strips the now-orphaned dependency imports from the
    // .swiftinterface, so consumers compile against the binary without
    // needing the packages at all.
    targets: [
        .binaryTarget(
            name: "IoTracker",
            url: "https://spm-sdk.technopartner.com.br/IoTracker/2.1.7/IoTracker.xcframework.zip",
            checksum: "add35e5ad273d4c080c2e76bcc1a0a7b7ce2e339f2eb606c84fea3aac47fd686"
        ),
    ]
)
