import AppKit
import SwiftUI

/// A tab an app exposes in its settings popover. Apps declare a `CaseIterable`
/// enum conforming to this; iUX renders the segmented switcher from `title`.
public protocol SettingsTab: Hashable, Identifiable, CaseIterable {
    /// Text shown in the segmented tab control.
    var title: String { get }
    /// SF Symbol name (used by apps for menus / status; optional in the bar).
    var icon: String { get }
}

// The settings popover shell — a segmented tab switcher above a fixed-width
// content column, exactly like Clonk's `PopoverView`. Apps supply the tab enum
// and a builder that returns the body for each tab; the chrome stays identical
// across every app.
public struct SettingsPopover<Tab: SettingsTab, Content: View>: View
where Tab.AllCases: RandomAccessCollection {
    @Binding var selection: Tab
    let width: CGFloat
    let content: (Tab) -> Content

    public init(
        selection: Binding<Tab>,
        width: CGFloat = UX.popoverWidth,
        @ViewBuilder content: @escaping (Tab) -> Content
    ) {
        self._selection = selection
        self.width = width
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Picker("", selection: $selection) {
                ForEach(Tab.allCases) { Text($0.title).tag($0) }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(.bottom, UX.tabBarSpacing)

            content(selection)
        }
        .padding(UX.popoverPadding)
        .frame(width: width)
        .onExitCommand { NSApp.keyWindow?.close() }
    }
}
