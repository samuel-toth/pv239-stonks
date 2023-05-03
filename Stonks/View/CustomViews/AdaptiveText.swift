import SwiftUI

struct AdaptiveText: View {
    let value: String
    let fontSizeThresholds: [Int: CGFloat]

    init(value: String, fontSizeThresholds: [Int: CGFloat] = [1: 20, 7: 16, 10: 12, 13: 10]) {
        self.value = value
        self.fontSizeThresholds = fontSizeThresholds
    }

    var body: some View {
        let fontSize = calculateFontSize(value: value)
        return Text(value)
            .font(.system(size: fontSize))
    }

    private func calculateFontSize(value: String) -> CGFloat {
        for (threshold, fontSize) in fontSizeThresholds.sorted(by: { $0.key < $1.key }) {
            if value.count < threshold {
                return fontSize
            }
        }
        return fontSizeThresholds.values.min() ?? 10
    }
}
