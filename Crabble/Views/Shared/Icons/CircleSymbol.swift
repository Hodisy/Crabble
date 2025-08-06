import SwiftUI

struct CircleSymbol: View {
    let iconName: String
    let iconColor: Color
    let backgroundColor: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: 32, height: 32)

            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 16)
                .foregroundColor(iconColor)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        CircleSymbol(
            iconName: "HeartIcon",
            iconColor: Color(hex: "#9333EA"),
            backgroundColor: Color(hex: "#F3E8FF")
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
