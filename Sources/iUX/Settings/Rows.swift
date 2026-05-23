import SwiftUI

// The standard settings rows. Each owns its own vertical padding so a
// `CardSection` can stack them with `Divider()`s between and get Clonk's
// spacing for free.

// MARK: - ToggleRow

/// A label (with optional subtitle) and a trailing switch.
public struct ToggleRow: View {
    let label: String
    let subtitle: String?
    @Binding var isOn: Bool

    public init(_ label: String, subtitle: String? = nil, isOn: Binding<Bool>) {
        self.label = label
        self.subtitle = subtitle
        self._isOn = isOn
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(.switch)
                .labelsHidden()
        }
        .padding(.vertical, UX.rowVPadding)
    }
}

// MARK: - SliderRow

/// A label, a slider, and a trailing read-out. Generic over the value range and
/// how the current value is formatted, so it covers everything from a 0–1
/// fraction to a stepped count.
public struct SliderRow: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double?
    let labelWidth: CGFloat
    let format: (Double) -> String

    public init(
        _ label: String,
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double? = nil,
        labelWidth: CGFloat = 72,
        format: @escaping (Double) -> String
    ) {
        self.label = label
        self._value = value
        self.range = range
        self.step = step
        self.labelWidth = labelWidth
        self.format = format
    }

    public var body: some View {
        HStack(spacing: 10) {
            Text(label).frame(width: labelWidth, alignment: .leading)
            if let step {
                Slider(value: $value, in: range, step: step)
            } else {
                Slider(value: $value, in: range)
            }
            Text(format(value))
                .monospacedDigit()
                .frame(width: 42, alignment: .trailing)
        }
        .padding(.vertical, UX.rowVPadding)
    }
}

public extension SliderRow {
    /// Convenience for the common 0–1 "percent" slider (Clonk's `VolumeRow`).
    static func percent(_ label: String, value: Binding<Double>, labelWidth: CGFloat = 72) -> SliderRow {
        SliderRow(label, value: value, in: 0...1, labelWidth: labelWidth) { v in
            "\(Int((v * 100).rounded()))%"
        }
    }
}

// MARK: - PlayButton

/// The circular tinted "preview" button used beside sound/voice pickers.
public struct PlayButton: View {
    let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: "play.circle.fill")
                .font(.system(size: 24))
                .foregroundStyle(.tint)
                .symbolRenderingMode(.hierarchical)
        }
        .buttonStyle(.plain)
        .help("Preview")
    }
}
