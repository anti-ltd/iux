import AppKit
import SwiftUI

// The menu-bar agent host, generalised from Clonk's AppDelegate. Installs an
// NSStatusItem whose left-click toggles a transient popover and whose right-
// click (or Control-click) shows an app-supplied NSMenu. Apps keep one of these
// alive for the process lifetime — typically a property on their app delegate.
@MainActor
public final class MenuBarController: NSObject {
    private var statusItem: NSStatusItem?
    private let popover = NSPopover()
    private let menuProvider: (@MainActor () -> NSMenu?)?

    /// - Parameters:
    ///   - symbolName: SF Symbol for the status-bar button.
    ///   - accessibilityLabel: VoiceOver description for the button.
    ///   - popoverSize: Initial content size (SwiftUI may resize height).
    ///   - rootView: The popover's SwiftUI content (usually a `SettingsPopover`).
    ///   - menuProvider: Optional right-click menu. Return `nil` to make right-
    ///     click behave like left-click. Rebuilt on every click, so it can
    ///     reflect live state.
    public init(
        symbolName: String,
        accessibilityLabel: String,
        popoverSize: NSSize,
        rootView: some View,
        menuProvider: (@MainActor () -> NSMenu?)? = nil
    ) {
        self.menuProvider = menuProvider
        super.init()
        popover.behavior = .transient
        popover.animates = true
        popover.contentSize = popoverSize
        popover.contentViewController = NSHostingController(rootView: rootView)
        installStatusItem(symbolName: symbolName, accessibilityLabel: accessibilityLabel)
    }

    /// Whether the popover is currently visible.
    public var isShown: Bool { popover.isShown }

    private func installStatusItem(symbolName: String, accessibilityLabel: String) {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = item.button {
            button.image = NSImage(systemSymbolName: symbolName, accessibilityDescription: accessibilityLabel)
            button.target = self
            button.action = #selector(handleClick(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        statusItem = item
    }

    @objc private func handleClick(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent
        let isRight = event?.type == .rightMouseUp ||
            (event?.modifierFlags.contains(.control) ?? false)
        if isRight, let menu = menuProvider?() {
            // Attach the menu just for this click, then detach so left-click
            // keeps toggling the popover instead of opening the menu.
            statusItem?.menu = menu
            sender.performClick(nil)
            statusItem?.menu = nil
        } else {
            toggle(from: sender)
        }
    }

    /// Toggle the popover. Pass a button to anchor to, or rely on the status item.
    public func toggle(from button: NSStatusBarButton? = nil) {
        guard let anchor = button ?? statusItem?.button else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: anchor.bounds, of: anchor, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
}
