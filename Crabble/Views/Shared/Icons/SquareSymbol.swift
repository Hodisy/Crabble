import SwiftUI

struct SquareSymbol: View {
    let iconName: String
    let iconColor: Color
    let backgroundColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .frame(width: 36, height: 36)

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
        SquareSymbol(
            iconName: "HeartIcon",
            iconColor: Color(hex: "#9333EA"),
            backgroundColor: Color(hex: "#F3E8FF")
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
