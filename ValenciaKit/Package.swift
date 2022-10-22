// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ValenciaKit",
  platforms: [
    .macOS(.v13),
    .iOS(.v16),
  ],
  products: [
    .library(name: "ValenciaKit", targets: ["ValenciaKit"])
  ],
  targets: [
    .target(name: "ValenciaKit")
  ]
)
