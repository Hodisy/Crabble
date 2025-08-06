import SwiftUI

struct GemmaBenefitsScreen: View {
    let onNext: () -> Void
    
    private let benefits = [
        ("Personalized Goals", "Tailored to your cognitive profile", "BrainIcon", Color(hex: "#4F46E5"), Color(hex: "#C7D2FE")),
        ("Fast Task Breakdown", "From blocked to clear in seconds", "FlashIcon", Color(hex: "#FF6F61"), Color(hex: "#FFF2EF")),
        ("100% On-Device", "Gemma 3n runs offline, privately", "LockIcon", Color(hex: "#00B894"), Color(hex: "#E8FAF5")),
        ("Context-Aware", "Understands your habits and needs", "LightIcon", Color(hex: "#FFC75F"), Color(hex: "#FFF8EB")),
        ("No Internet Required", "Works anytime, anywhere, fully offline", "WifiOffIcon", Color(hex: "#7289DA"), Color(hex: "#EDF1FF")),
        ("Totally Free", "No subscription, no upsell, no ads", "HandCoinIcon", Color(hex: "#FF9F1C"), Color(hex: "#FFF5E6"))
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            // Title and Subtitle
            VStack(spacing: 16) {
                Text("Private Smart Free")
                    .font(.system(size: 24, weight: .bold))
                    .lineSpacing(32 - 24) // Adjust line height to 32px
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#1F2937"))

                Text("Your daily mental coach always on device, always private")
                    .font(.system(size: 16, weight: .regular))
                    .lineSpacing(26 - 16) // Adjust line height to 26px
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#4B5563"))
                    .padding(.horizontal, 24)
                    .fixedSize(horizontal: false, vertical: true)
            }.padding(.top, 24)

            // Benefits List
            VStack(spacing: 12) {
                ForEach(benefits, id: \.0) { benefit in
                    BenefitCard(
                        title: benefit.0, 
                        subtitle: benefit.1,
                        iconName: benefit.2,
                        iconColor: benefit.3,
                        backgroundColor: benefit.4
                    )
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // Button
            Button(action: onNext) {
                Text("Begin Your Journey")
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
                    Color(hex: "#fdf2f8")
                ],
                startPoint: UnitPoint(x: 0, y: 0),
                endPoint: UnitPoint(x: 1, y: 1)
            )
        )
    }
}

struct BenefitCard: View {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: Color
    let backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            CircleSymbol(
                iconName: iconName,
                iconColor: iconColor,
                backgroundColor: backgroundColor
            )
            
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "#1F2937"))
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(hex: "#374151"))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.6))
        )
    }
}

#Preview {
    GemmaBenefitsScreen(onNext: {})
} 
