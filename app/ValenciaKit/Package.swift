// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ValenciaKit",
  platforms: [
    .macOS(.v15),
    .iOS(.v18),
  ],
  products: [
    .library(name: "ValenciaKit", targets: ["ValenciaKit"])
  ],
  dependencies: [
    .package(url: "https://github.com/SwiftyLab/MetaCodable.git", from: "1.0.0")
  ],
  targets: [
    .target(name: "CoreLocationCodable"),
    .target(
      name: "ValenciaKit",
      dependencies: [
        "CoreLocationCodable",
        .product(name: "MetaCodable", package: "MetaCodable"),
        .product(name: "HelperCoders", package: "MetaCodable"),
      ]
    ),
  ]
)
