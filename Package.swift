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
                      checksum: "435145934a56ec0bf5c840cbeac934f8bc73606125ff9b5d379e925e022e80ff")
    ]
)
