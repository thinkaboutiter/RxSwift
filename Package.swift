// swift-tools-version:5.0

import PackageDescription

let buildTests = false

extension Product {
  static func allTests() -> [Product] {
    if buildTests {
      return [.executable(name: "AllTestz", targets: ["AllTestz"])]
    } else {
      return []
    }
  }
}

extension Target {
  static func rxCocoa() -> [Target] {
    #if os(Linux)
      return [.target(name: "RxCocoa", dependencies: ["RxSwift", "RxRelay"])]
    #else
      return [.target(name: "RxCocoa", dependencies: ["RxSwift", "RxRelay", "RxCocoaRuntime"])]
    #endif
  }

  static func rxCocoaRuntime() -> [Target] {
    #if os(Linux)
      return []
    #else
      return [.target(name: "RxCocoaRuntime", dependencies: ["RxSwift"])]
    #endif
  }

  static func allTests() -> [Target] {
    if buildTests {
      return [.target(name: "AllTestz", dependencies: ["RxSwift", "RxCocoa", "RxBlocking", "RxTest"])]
    } else {
      return []
    }
  }
}

let package = Package(
  name: "RxSwift",
  platforms: [
    .macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v3)
  ],
  products: ([
    [
      .library(name: "RxSwift", type: .dynamic, targets: ["RxSwift"]),
      .library(name: "RxCocoa", type: .dynamic, targets: ["RxCocoa"]),
      .library(name: "RxRelay", type: .dynamic, targets: ["RxRelay"]),
      .library(name: "RxBlocking", type: .dynamic, targets: ["RxBlocking"]),
      .library(name: "RxTest", type: .dynamic, targets: ["RxTest"]),
    ],
    Product.allTests()
  ] as [[Product]]).flatMap { $0 },
  targets: ([
    [
      .target(name: "RxSwift", dependencies: []),
    ], 
    Target.rxCocoa(),
    Target.rxCocoaRuntime(),
    [
      .target(name: "RxRelay", dependencies: ["RxSwift"]),
      .testTarget(name: "RxBlocking", dependencies: ["RxSwift"]),
      .testTarget(name: "RxTest", dependencies: ["RxSwift"]),
    ],
    Target.allTests()
  ] as [[Target]]).flatMap { $0 },
  swiftLanguageVersions: [.v5]
)
