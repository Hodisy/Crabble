import SwiftUI

struct TaskFocusModeSelector: View {
    @State private var selectedFocusMode: TaskFocusOption = .silence
    
    let onFocusModeSelected: (TaskFocusOption) -> Void
    
    enum TaskFocusOption: String, CaseIterable {
        case music = "With music"
        case silence = "In silence"
        case focusMode = "Focus mode on"
        case timer = "With timer"
        
        var icon: String {
            switch self {
            case .music: return "music.note"
            case .silence: return "speaker.slash"
            case .focusMode: return "iphone.slash"
            case .timer: return "timer"
            }
        }
        
        var description: String {
            switch self {
            case .music: return "Note de musique + écouteurs"
            case .silence: return "Haut-parleur barré"
            case .focusMode: return "Téléphone en mode \"ne pas déranger\""
            case .timer: return "Chronomètre"
            }
        }
    }
    
    init(onFocusModeSelected: @escaping (TaskFocusOption) -> Void = { _ in }) {
        self.onFocusModeSelected = onFocusModeSelected
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Title
            HStack(spacing: 8) {
                Image(systemName: "brain")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "374151"))
                
                Text("What will help you stay focused?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "374151"))
            }
            
            // Focus Options Grid (2x2)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(TaskFocusOption.allCases, id: \.self) { option in
                    FocusModeButton(
                        option: option,
                        isSelected: selectedFocusMode == option,
                        onTap: {
                            selectedFocusMode = option
                            onFocusModeSelected(option)
                        }
                    )
                }
            }
        }
    }
}

struct FocusModeButton: View {
    let option: TaskFocusModeSelector.TaskFocusOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Icon
                Image(systemName: option.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? Color(hex: "1E40AF") : Color(hex: "6B7280"))
                
                // Label
                Text(option.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? Color(hex: "1E40AF") : Color(hex: "1F2937"))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(height: 80)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color(hex: "EFF6FF") : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected ? Color(hex: "BFDBFE") : Color(hex: "E5E7EB"),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        TaskFocusModeSelector { focusMode in
            print("Selected focus mode: \(focusMode.rawValue)")
        }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
} 