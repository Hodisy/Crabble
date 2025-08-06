import SwiftUI

struct TaskEnvironmentPreparation: View {
    @State private var environmentText: String = ""
    
    let onEnvironmentChanged: (String) -> Void
    let onSuggestionSelected: (String) -> Void
    
    let environmentSuggestions = [
        "Make a tea first",
        "Play lo-fi playlist",
        "Breathe, then take one action"
    ]
    
    init(
        onEnvironmentChanged: @escaping (String) -> Void = { _ in },
        onSuggestionSelected: @escaping (String) -> Void = { _ in }
    ) {
        self.onEnvironmentChanged = onEnvironmentChanged
        self.onSuggestionSelected = onSuggestionSelected
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Title
            HStack(spacing: 8) {
                // Circle with gradient and icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "C7D2FE"), Color(hex: "E9D5FF")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "leaf")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "4F46E5"))
                }
                
                Text("How will you set the scene?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "374151"))
            }
            
            // Free text input area
            VStack(alignment: .leading, spacing: 8) {
                TextField("Make tea, open window, breathe deeply…", text: $environmentText, axis: .vertical)
                    .font(.system(size: 14, weight: .regular))
                    .lineLimit(3...6)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onChange(of: environmentText) { newValue in
                        onEnvironmentChanged(newValue)
                    }
            }
            
            // Crabby's Suggestions using CrabbyThinks component
            CrabbyThinks(
                bodyText: "Rituals that usually help to start well:",
                suggestions: environmentSuggestions
            )
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        TaskEnvironmentPreparation(
            onEnvironmentChanged: { text in
                print("Environment text: \(text)")
            },
            onSuggestionSelected: { suggestion in
                print("Selected suggestion: \(suggestion)")
            }
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
} 