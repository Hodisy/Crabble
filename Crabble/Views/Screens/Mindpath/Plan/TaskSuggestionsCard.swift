import SwiftUI

struct TaskSuggestionsCard: View {
    let suggestions: [String]
    let onRegenerate: (() -> Void)?
    
    @State private var isRegenerating = false
    
    init(suggestions: [String] = [], onRegenerate: (() -> Void)? = nil) {
        self.suggestions = suggestions.isEmpty ? [
            "Schedule during your natural energy peaks",
            "Choose a location with minimal distractions",
            "Prepare everything you need in advance"
        ] : suggestions
        self.onRegenerate = onRegenerate
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main card
            HStack(alignment: .top, spacing: 16) {
                // Sparkle icon
                ZStack {
                    Circle()
                        .fill(Color(hex: "F3E8FF"))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "9333EA"))
                }
                
                // Content
                VStack(alignment: .leading, spacing: 12) {
                    // Title
                    Text("Smart suggestions:")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "581C87"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Suggestions list
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(suggestions, id: \.self) { suggestion in
                            HStack(alignment: .top, spacing: 8) {
                                // Bullet point
                                Text("•")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color(hex: "6B21A8"))
                                    .padding(.top, 1)
                                
                                // Suggestion text
                                Text(suggestion)
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundColor(Color(hex: "6B21A8"))
                                    .lineSpacing(20 - 14)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
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
            
            // Regenerate action (if provided)
            if onRegenerate != nil {
                Button(action: {
                    isRegenerating = true
                    onRegenerate?()
                    
                    // Reset spinning state after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isRegenerating = false
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .medium))
                            .rotationEffect(.degrees(isRegenerating ? 360 : 0))
                            .animation(
                                isRegenerating ? 
                                Animation.linear(duration: 1).repeatForever(autoreverses: false) : 
                                .default,
                                value: isRegenerating
                            )
                        
                        Text("Regenerate")
                            .font(.system(size: 14, weight: .medium))
                    }
                    .foregroundColor(Color(hex: "A855F7"))
                }
                .padding(.top, 12)
                .disabled(isRegenerating)
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        // Default suggestions
        TaskSuggestionsCard()
        
        // Custom suggestions with regenerate action
        TaskSuggestionsCard(
            suggestions: [
                "Break down the task into smaller steps",
                "Set a specific time limit for this activity",
                "Remove all potential distractions from your environment"
            ],
            onRegenerate: {
                print("Regenerating suggestions...")
            }
        )
        
        // Without regenerate action
        TaskSuggestionsCard(
            suggestions: [
                "Take a short break every 25 minutes",
                "Use the Pomodoro technique",
                "Keep your phone in another room"
            ]
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
} 