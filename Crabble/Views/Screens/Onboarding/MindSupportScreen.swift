import SwiftUI

struct MindSupportScreen: View {
    let onNext: () -> Void
    @State private var selectedMindType: MindType?
    
    var body: some View {
        VStack(spacing: 24) {
            // Title and Subtitle
            VStack(spacing: 16) {
                Text("Let's begin here")
                    .font(.system(size: 24, weight: .bold))
                    .lineSpacing(32 - 24) // Adjust line height to 32px
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#1F2937"))
                    .padding(.horizontal, 24)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Share how your mind works to enable better support")
                    .font(.system(size: 16, weight: .semibold))
                    .lineSpacing(24 - 16) // Line height 24px
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#1F2937"))
                    .padding(.horizontal, 24)
                    .fixedSize(horizontal: false, vertical: true)
            }.padding(.top, 24)

            // Selection Cards
            VStack(spacing: 12) {
                ForEach(MindType.allCases, id: \.self) { mindType in
                    MindTypeCard(
                        mindType: mindType,
                        isSelected: selectedMindType == mindType
                    ) {
                        selectedMindType = mindType
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // Continue Button
            Button(action: onNext) {
                Text(selectedMindType != nil ? "Continue" : "Tell us about you")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(selectedMindType != nil ? .white : Color(hex: "#9CA3AF"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        Group {
                            if selectedMindType != nil {
                                LinearGradient(
                                    colors: [.purple, .pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            } else {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                    )
                    .cornerRadius(16)
                    .shadow(color: selectedMindType != nil ? .purple.opacity(0.3) : .clear, radius: 8, x: 0, y:4)
            }
            .disabled(selectedMindType == nil)
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

struct MindTypeCard: View {
    let mindType: MindType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 16) {
                // Header with title and selection icon
                HStack {
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text(mindType.rawValue)
                            .font(.system(size: 16, weight: .semibold))
                            .lineSpacing(24 - 16) // Line height 24px
                            .foregroundColor(Color(hex: "#1F2937"))
                            .multilineTextAlignment(.center)
                        
                        // Show subtitle only when not selected (with DefaultCrabble)
                        if !isSelected {
                            Text(mindType.subtitle)
                                .font(.system(size: 14))
                                .lineSpacing(20 - 14) // Line height 20px
                                .foregroundColor(Color(hex: "#4B5563"))
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    Spacer()
                    
                    // Selection indicator
                    if isSelected {
                        Image("CheckIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(iconBackgroundColor)
                            )
                    }
                }
                
                // Image with fixed width
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 160, height: 120)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .background(
                Group {
                    if isSelected {
                        if let gradient = backgroundGradient {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(gradient)
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ultraThinMaterial)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(strokeColor, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var imageName: String {
        if isSelected {
            switch mindType {
            case .adhd:
                return "ExplodingCrabble"
            case .anxiety:
                return "PerseveringCrabble"
            }
        } else {
            return "DefaultCrabble"
        }
    }
    
    private var iconBackgroundColor: Color {
        switch mindType {
        case .adhd:
            return Color(hex: "#F97316")
        case .anxiety:
            return Color(hex: "#A855F7")
        }
    }
    
    private var strokeColor: Color {
        if isSelected {
            switch mindType {
            case .adhd:
                return Color(hex: "#FED7AA")
            case .anxiety:
                return Color(hex: "#E9D5FF")
            }
        } else {
            return Color.purple.opacity(0.2)
        }
    }
    
    private var backgroundGradient: LinearGradient? {
        if isSelected {
            switch mindType {
            case .adhd:
                return LinearGradient(
                    colors: [Color(hex: "#FFF7ED"), Color(hex: "#FEF2F2")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .anxiety:
                return LinearGradient(
                    colors: [Color(hex: "#FAF5FF"), Color(hex: "#EFF6FF")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        return nil
    }
}

#Preview {
    MindSupportScreen(onNext: {})
}
