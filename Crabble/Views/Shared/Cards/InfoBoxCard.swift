import SwiftUI

struct InfoBoxCard: View {
    let title: String
    let subtitle: String
    
    init(title: String = "Smart suggestions:", subtitle: String = "Here are some common thoughts that make this feel harder:") {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Badge circulaire avec icône sparkle
            ZStack {
                Circle()
                    .fill(Color(hex: "F3E8FF"))
                    .frame(width: 32, height: 32)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "9333EA"))
            }
            
            // Texte à droite
            VStack(alignment: .leading, spacing: 4) {
                // Titre
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .lineSpacing(24 - 16)
                    .foregroundColor(Color(hex: "581C87"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Sous-titre
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .lineSpacing(20 - 14)
                    .foregroundColor(Color(hex: "6B21A8"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "FAF5FF"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "F3E8FF"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack(spacing: 16) {
        // Exemple par défaut
        InfoBoxCard()
        
        // Exemple personnalisé
        InfoBoxCard(
            title: "Pro tip:",
            subtitle: "Try breaking down your goal into smaller, manageable steps."
        )
        
        // Exemple avec texte plus long
        InfoBoxCard(
            title: "Did you know?",
            subtitle: "Taking short breaks every 25 minutes can significantly improve your focus and productivity throughout the day."
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
} 