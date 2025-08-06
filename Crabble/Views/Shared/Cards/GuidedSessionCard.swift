import SwiftUI

struct GuidedSessionCard: View {
    let onBeginTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Left side content
            VStack(alignment: .leading, spacing: 4) {
                Text("Start a Guided Session")
                    .font(.system(size: 16, weight: .semibold))
                    .lineSpacing(24 - 16)
                    .foregroundColor(Color(hex: "1E3A8A"))
                
                Text("Break down tasks with\ncognitive support")
                    .font(.system(size: 14, weight: .regular))
                    .lineSpacing(20 - 14)
                    .foregroundColor(Color(hex: "1D4ED8"))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            // Right side button
            Button(action: onBeginTapped) {
                HStack(spacing: 6) {
                    TargetIcon(size: 16, color: .white)
                    
                    Text("Begin")
                        .font(.system(size: 14, weight: .medium))
                        .lineSpacing(20 - 14)
                        .foregroundColor(.white)
                }
                .frame(width: 88, height: 36)
                .background(Color(hex: "2563EB"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "EFF6FF"),
                    Color(hex: "EEF2FF")
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "DBEAFE"), lineWidth: 1)
                .offset(x: -0.5, y: -0.5)
        )
    }
}

#Preview {
    GuidedSessionCard(onBeginTapped: {
        print("Begin tapped")
    })
        .padding()
        .background(Color.gray.opacity(0.1))
} 