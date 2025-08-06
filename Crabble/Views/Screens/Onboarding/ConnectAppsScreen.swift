import SwiftUI

struct ConnectAppsScreen: View {
    let onNext: () -> Void

    private let apps = [
        ("Apple Health", "Mindfulness sessions", "ActivityIcon", Color(hex: "#DC2626"), Color(hex: "#FEE2E2")),
        ("Calendar", "Focus blocks & reminders", "CalendarIcon", Color(hex: "#2563EB"), Color(hex: "#DBEAFE")),
        ("Apple Music", "Focus playlists", "MusicIcon", Color(hex: "#DB2777"), Color(hex: "#FCE7F3")),
        ("Smart Notifications", "Context-aware reminders", "BellIcon", Color(hex: "#CA8A04"), Color(hex: "#FEF9C3")),
        ("Focus Mode", "Auto-enable during sessions", "SmartphoneIcon", Color(hex: "#9333EA"), Color(hex: "#F3E8FF")),
    ]

    var body: some View {
        VStack(spacing: 24) {
            // Title and Subtitle
            VStack(spacing: 16) {
                Text("Connect your apps")
                    .font(.system(size: 24, weight: .bold))
                    .lineSpacing(32 - 24) // Adjust line height to 32px
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#1F2937"))
                    .padding(.horizontal, 24)
                    .fixedSize(horizontal: false, vertical: true)

                Text("Connect Crabby with your favorite apps")
                    .font(.system(size: 16, weight: .regular))
                    .lineSpacing(24 - 16) // Line height 24px
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#4B5563"))
                    .padding(.horizontal, 24)
                    .fixedSize(horizontal: false, vertical: true)
            }.padding(.top, 24)

            // Connect Cards List
            VStack(spacing: 14) {
                ForEach(apps, id: \.0) { app in
                    ConnectCard(
                        title: app.0,
                        subtitle: app.1,
                        iconName: app.2,
                        iconColor: app.3,
                        backgroundColor: app.4
                    )
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // Continue Button
            Button(action: onNext) {
                Text("Start Exploring")
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
                    Color(hex: "#EFF6FF"),
                    Color(hex: "#FAF5FF"),
                    Color(hex: "#FDF2F8"),
                ],
                startPoint: UnitPoint(x: 0, y: 0),
                endPoint: UnitPoint(x: 1, y: 1)
            )
        )
    }
}

struct ConnectCard: View {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: Color
    let backgroundColor: Color
    @State private var isToggled: Bool = false

    var body: some View {
        HStack(spacing: 12) { // Réduire l'espacement de 16 à 12
            SquareSymbol(
                iconName: iconName,
                iconColor: iconColor,
                backgroundColor: backgroundColor
            )

            VStack(alignment: .leading, spacing: 2) { // Réduire l'espacement entre title/subtitle
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "#1F2937"))
                    .lineLimit(1) // Forcer sur une ligne
                    .minimumScaleFactor(0.8) // Permettre de réduire légèrement la taille si nécessaire

                Text(subtitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(hex: "#374151"))
                    .lineLimit(2) // Permettre maximum 2 lignes pour le subtitle
                    .minimumScaleFactor(0.9)
            }

            Spacer(minLength: 8) // Assurer un minimum d'espace

            Toggle("", isOn: $isToggled)
                .toggleStyle(SwitchToggleStyle(tint: .black))
                .scaleEffect(0.8)
                .frame(width: 40) // Limiter la largeur du Toggle
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.6))
        )
    }
}

#Preview {
    ConnectAppsScreen(onNext: {})
}
