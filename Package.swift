// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "VaporKindergarten",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0-rc.2"),

        // 🍃 Leaf template engine.
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc.2"),

        // 🖋🐬 Swift ORM (queries, models, relations, etc) built on MySQL.
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0-rc.2"),

        // Crypto
        .package(url: "https://github.com/vapor/crypto.git", from: "3.1.1")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "Leaf", "FluentMySQL", "Crypto"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
