// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let url = "https://cdn.appdynamics.com/eum-mobile/iOSAgent-2023.7.0.4175.zip"
let checksum = "b49ede8f76fc161b8aac92ecbf9de1f2a442ca3f94ed6d458beb54abf5b658e6"

let package = Package(
    name: "AppDynamicsAgent",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "AppDynamicsAgent", targets: ["AppDynamicsAgent"]),
    ],
    targets: [
        .binaryTarget(name: "AppDynamicsAgent", url: url, checksum: checksum)
    ]
)
