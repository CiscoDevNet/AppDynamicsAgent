// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.
//  Copyright (c) 2023 AppDynamics Technologies. All rights reserved.

import PackageDescription

let package = Package(
    name: "AppDynamicsAgent",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "AppDynamicsAgent", targets: ["ADEUMInstrumentation"]),
    ],
    targets: [
        .binaryTarget(name: "ADEUMInstrumentation",
                      url: "https://cdn.appdynamics.com/eum-mobile/iOSAgent-2023.8.0.zip",
                      checksum: "ad9df9cdf4daff313c47686255d00f7574907bca7200a35be3c1943961fd9929")
    ]
)
