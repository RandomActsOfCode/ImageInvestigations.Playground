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
    .package(url: "https://github.com/pointfreeco/swift-identified-collections", from: "0.3.2"),
    .package(url: "https://github.com/pointfreeco/swift-tagged", from: "0.7.0"),
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
      dependencies: [
        .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
        .product(name: "Tagged", package: "swift-tagged"),
      ],
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
