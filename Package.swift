// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BPSuperCard",
  platforms: [.iOS(.v11)],
  products: [
    .library(
      name: "BPSuperCard",
      targets: ["BPSuperCard"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "BPSuperCard",
      dependencies: []),
    .testTarget(
      name: "BPSuperCardTests",
      dependencies: ["BPSuperCard"]
    ),
  ]
)
