// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "MediaInvestigations",
  platforms: [.iOS(.v15)],
  products: [
    .library(
      name: "MediaPlayground",
      targets: ["MediaPlayground"]
    ),
    .library(
      name: "ViewHelpers",
      targets: ["ViewHelpers"]
    ),
    .library(
      name: "MediaAssets",
      targets: ["MediaAssets"]
    ),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "MediaPlayground",
      dependencies: [
        "MediaAssets",
        "ViewHelpers",
      ],
      path: "Sources/MediaPlayground"
    ),
    .target(
      name: "ViewHelpers",
      dependencies: [],
      path: "Sources/ViewHelpers"
    ),
    .target(
      name: "MediaAssets",
      dependencies: [
        "ViewHelpers",
      ],
      path: "Sources/MediaAssets",
      resources: [
        .process("Resources"),
      ]
    ),
    .testTarget(
      name: "ViewHelperTests",
      dependencies: [
        "ViewHelpers",
      ],
      path: "Tests/ViewHelperTests"
    ),
  ]
)
