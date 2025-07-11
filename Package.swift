// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ImportedExtensions",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "ImportedExtensions",
            targets: ["ImportedExtensions"]
        ),
    ],
    targets: [
        .target(
            name: "ImportedExtensions",
            dependencies: []
        )
    ]
)
