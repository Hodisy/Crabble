import SwiftUI

struct WelcomeScreen: View {
    let onNext: () -> Void
    @State private var shouldTriggerBubble = false

    var body: some View {
        VStack(spacing: 24) {
            // Title and Subtitle
            VStack(spacing: 16) {
                Text("Welcome to Crabble")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(hex: "#1F2937"))
                    .lineSpacing(26 - 28) // Adjust line height to 26px

                Text("Your gentle companion app for building focus and reducing task avoidance, one small step at a time")
                    .font(.system(size: 15, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#4B5563"))
                    .padding(.horizontal, 24)
            }.padding(.top, 24)

            // Rive Animation
            InteractiveRiveView(
                resourceName: "crabble-light",
                stateMachineName: nil,
                triggerBubble: $shouldTriggerBubble
            )
            .frame(height: 200)
            .background(Color.clear)
            .onTapGesture {
                shouldTriggerBubble = true
            }

            Spacer()

            // Benefits
            VStack(spacing: 16) {
                BenefitRow(
                    symbol: CircleSymbol(
                        iconName: "CheckIcon",
                        iconColor: Color(hex: "#16A34A"),
                        backgroundColor: Color(hex: "#DCFCE7")
                    ),
                    text: "Daily micro-goals that feel manageable"
                )
                BenefitRow(
                    symbol: CircleSymbol(
                        iconName: "ClockIcon",
                        iconColor: Color(hex: "#2563EB"),
                        backgroundColor: Color(hex: "#DBEAFE")
                    ),
                    text: "Guided focus sessions"
                )
                BenefitRow(
                    symbol: CircleSymbol(
                        iconName: "HeartIcon",
                        iconColor: Color(hex: "#9333EA"),
                        backgroundColor: Color(hex: "#F3E8FF")
                    ),
                    text: "Gentle nudges, no pressure"
                )
            }
            .padding(.horizontal, 24)

            // Button
            Button(action: onNext) {
                Text("Let's Start")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                    .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "#eff6ff"),
                    Color(hex: "#ccf5ff"),
                    Color(hex: "#fdf2f8"),
                ],
                startPoint: UnitPoint(x: 0, y: 0),
                endPoint: UnitPoint(x: 1, y: 1)
            )
        )
    }
}

struct BenefitRow: View {
    let symbol: CircleSymbol
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            symbol

            Text(text)
                .font(.system(size: 13, weight: .regular))
                .lineSpacing(24 - 15) // Adjust line height to 24px
                .foregroundColor(Color(hex: "#374151"))

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.6))
        )
    }
}

#Preview {
    WelcomeScreen(onNext: {})
}
