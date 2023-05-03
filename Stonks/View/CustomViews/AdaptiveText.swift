import SwiftUI

struct AdaptiveText: View {
    let value: String

    var body: some View {
        let fontSize = calculateFontSize(value: value)
        return Text(value)
            .font(.system(size: fontSize))
    }

    private func calculateFontSize(value: String) -> CGFloat {
        switch value.count {
        case 1...6:
            return 20
        case 7...9:
            return 16
        case 10...12:
            return 12
        default:
            return 10
        }
    }
}
