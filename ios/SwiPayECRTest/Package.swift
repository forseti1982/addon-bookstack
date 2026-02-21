// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiPayECRTest",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "SwiPayECRTest", targets: ["SwiPayECRTest"])
    ],
    targets: [
        .target(name: "SwiPayECRTest", path: "App")
    ]
)
