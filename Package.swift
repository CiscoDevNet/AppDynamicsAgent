// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppDynamicsAgent",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "AppDynamicsAgent", targets: ["AppDynamicsAgent"]),
    ],
    targets: [
        .binaryTarget(name: "AppDynamicsAgent",
                      url: "https://cdn.appdynamics.com/eum-mobile/iOSAgent-2023.8.0.4197.zip",
                      checksum: "520fb6a6edafb331f7dd3c72c9b337e7ee84d63a9d396d924135c6e98b340f7a")
    ]
)
