// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "URLWatcher",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        
        // Load the driver for sqlite3
        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),

        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "App", dependencies: ["Leaf", "Vapor", "FluentSQLite"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

