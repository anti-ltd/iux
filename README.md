# iUX

**The shared UX layer for our macOS apps.**

iUX is a tiny, source-only Swift package. Every app links it and gets the same
settings popover, menu-bar agent and floating overlay windows — so we stop
re-coding widget chrome, settings layouts and popover styling app by app.

The components, spacing and styling are lifted straight from **Clonk** so apps
already built by hand keep matching pixel-for-pixel after migrating.

It's source-only and static-linked, so each app's binary only pays for the
pieces it actually uses.

---

## Install

Add it as a local dependency in an app's `Package.swift`:

```swift
dependencies: [
    .package(path: "../iUX"),
],
targets: [
    .executableTarget(
        name: "MyApp",
        dependencies: ["iUX"],
        path: "Sources/MyApp"
    ),
]
```

Then `import iUX`.

---

## What's inside

### Design tokens — `UX`
The single source of truth for the look: popover width/padding, card spacing,
row padding, and the dark-glass panel radius/opacities. Change a number here and
every app moves together.

### Settings / popover kit
- **`SettingsPopover`** — the segmented tab switcher over a fixed-width content
  column. Supply a `SettingsTab` enum and a per-tab content builder.
- **`CardSection`** — a titled group of rows.
- **`ToggleRow`** — label (+ optional subtitle) and a switch.
- **`SliderRow`** — label, slider and read-out; `.percent(…)` for 0–1 sliders.
- **`PlayButton`** — the circular tinted preview button.

### Menu-bar host — `MenuBarController`
Installs an `NSStatusItem`: left-click toggles a transient popover, right-click
(or Control-click) shows an app-supplied `NSMenu`. Keep one alive on your app
delegate.

### Overlay window system
- **`OverlayWindow<Content>`** — a borderless, draggable, always-on-top panel
  that joins every Space, stays out of the Dock/Cmd-Tab, and persists its frame
  per name.
- **`.glassPanel()`** — the dark-glass chrome (rounded fill + hairline border)
  for the content you put inside an overlay.

---

## Usage sketch

```swift
import iUX
import SwiftUI

enum Tab: String, SettingsTab {
    case general, about
    var id: String { rawValue }
    var title: String { rawValue.capitalized }
    var icon: String { self == .general ? "slider.horizontal.3" : "info.circle" }
}

struct RootView: View {
    @State private var tab: Tab = .general
    @State private var enabled = true
    @State private var volume = 0.8

    var body: some View {
        SettingsPopover(selection: $tab) { tab in
            switch tab {
            case .general:
                CardSection("Output") {
                    ToggleRow("Enabled", isOn: $enabled)
                    Divider()
                    SliderRow.percent("Volume", value: $volume)
                }
            case .about:
                CardSection { Text("MyApp 1.0") }
            }
        }
    }
}

// In the app delegate:
menuBar = MenuBarController(
    symbolName: "sparkles",
    accessibilityLabel: "MyApp",
    popoverSize: NSSize(width: UX.popoverWidth, height: 400),
    rootView: RootView()
)

// A floating widget overlay:
let overlay = OverlayWindow(name: "widget", size: NSSize(width: 220, height: 90)) {
    Text("hello").padding().glassPanel(padding: 12)
}
overlay.show()
```
