import SwiftUI

// The dark-glass panel chrome shared by every floating overlay (Clonk's key
// visualizer, WPM readout, etc.): a rounded, semi-transparent black fill with
// a faint white hairline border. Defaults come from `UX` so all overlays match.
public struct GlassPanel: ViewModifier {
    var cornerRadius: CGFloat
    var fillOpacity: Double
    var borderOpacity: Double
    var padding: CGFloat?

    public func body(content: Content) -> some View {
        Group {
            if let padding {
                content.padding(padding)
            } else {
                content
            }
        }
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.black.opacity(fillOpacity))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(.white.opacity(borderOpacity), lineWidth: 1)
        )
    }
}

public extension View {
    /// Wrap a view in iUX's dark-glass overlay chrome. Pass `padding` to inset
    /// the content from the rounded edge in one call.
    func glassPanel(
        cornerRadius: CGFloat = UX.panelCornerRadius,
        fillOpacity: Double = UX.panelFillOpacity,
        borderOpacity: Double = UX.panelBorderOpacity,
        padding: CGFloat? = nil
    ) -> some View {
        modifier(GlassPanel(
            cornerRadius: cornerRadius,
            fillOpacity: fillOpacity,
            borderOpacity: borderOpacity,
            padding: padding
        ))
    }
}
