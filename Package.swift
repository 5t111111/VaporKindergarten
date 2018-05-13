// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "VaporKindergarten",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.2"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0-rc"),
        .package(url: "https://github.com/vapor/crypto.git", from: "3.1.2"),
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc.4")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "Leaf", "FluentPostgreSQL", "Crypto", "Authentication"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
