// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.
// SPDX-License-Identifier: Apache-2.0
// Copyright © 2023 Cisco Systems, Inc. and its affiliates.
// All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import PackageDescription

let package = Package(
    name: "AppDynamicsAgent",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "AppDynamicsAgent", targets: ["ADEUMInstrumentation"]),
    ],
    targets: [
        .binaryTarget(name: "ADEUMInstrumentation",
                      url: "https://appdynamics.jfrog.io/artifactory/maven-releases/com/appdynamics/eum/iOSAgentSPM/2025.2.0.4618/iOSAgentSPM-2025.2.0.4618.zip",
                      checksum: "9cce42449a25bbeede702d60cf17635494b5c370bf9633453f850f6dfcd352a2")
    ]
)
