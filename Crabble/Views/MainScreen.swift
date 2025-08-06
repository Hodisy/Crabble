import SwiftUI

struct MainScreen: View {
    @State private var shouldTriggerBubble = false
    @State private var showingMindpath = false

    var body: some View {
        VStack(spacing: 24) {
            // Title and Subtitle
            VStack(spacing: 16) {
                Text("Welcome to Crabble")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(hex: "#1F2937"))
                    .lineSpacing(26 - 28) // Adjust line height to 26px

                // Crabby Thinks Card
                CrabbyThinks(
                    bodyText: "You planned to tackle your FAFSA today. Just 5 minutes to feel lighter.",
                    hasFixedSize: true,
                    maxLines: 2
                )
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

            // Mind Journey Card
            MindJourneyCard()
                .padding(.horizontal, 24)

            // Guided Session Card
            GuidedSessionCard(onBeginTapped: {
                showingMindpath = true
            })
            .padding(.horizontal, 24)
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
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingMindpath) {
            MindpathFlowScreen()
        }
    }
}

#Preview {
    MainScreen()
}
