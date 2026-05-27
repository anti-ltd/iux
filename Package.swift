// swift-tools-version: 6.1
import PackageDescription

// iUX-MacOS — the shared UX layer for our macOS apps.
//
// A tiny, source-only SwiftPM library. Apps add it as a local/git dependency
// and `import iUX_MacOS` to get the same settings popover, menu-bar host and
// floating overlay windows everywhere — no recoding the same widget chrome per
// app. Static-linked and dead-code-stripped, so each app only pays for what it
// uses.
let package = Package(
    name: "iUX-MacOS",
    platforms: [.macOS("26.0")],
    products: [
        .library(name: "iUX-MacOS", targets: ["iUX-MacOS"]),
    ],
    targets: [
        .target(
            name: "iUX-MacOS",
            path: "Sources/iUX-MacOS"
        ),
    ]
)
