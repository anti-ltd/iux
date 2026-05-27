import SwiftUI

// A titled group of rows — the basic unit of an iUX settings panel. An optional
// secondary header sits above a left-aligned content stack. Rows inside are
// expected to separate themselves with `Divider()`, matching Clonk's popover.
public struct CardSection<Content: View>: View {
    let title: String?
    @ViewBuilder var content: Content

    public init(_ title: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }
            VStack(alignment: .leading, spacing: 0) { content }
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
