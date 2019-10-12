// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "Reactions",
  platforms: [
    .iOS(.v11)
  ],
  products: [
    .library(name: "Reactions", targets: ["Reactions"]),
  ],
  targets: [
    .target(
      name: "Reactions",
      dependencies: [],
      path: "Sources"),
    .testTarget(
      name: "ReactionsTests",
      dependencies: ["Reactions"],
      path: "Tests"),
  ]
)


