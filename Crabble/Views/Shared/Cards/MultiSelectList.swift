import SwiftUI

struct MultiSelectOption: Identifiable {
    let id = UUID()
    let title: String
}

struct MultiSelectList: View {
    let title: String
    let options: [MultiSelectOption]
    @Binding var selectedOptions: Set<UUID>
    
    init(title: String = "Select your feelings:", options: [MultiSelectOption], selectedOptions: Binding<Set<UUID>>) {
        self.title = title
        self.options = options
        self._selectedOptions = selectedOptions
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .lineSpacing(24 - 16)
                .foregroundColor(Color(hex: "374151"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Options list
            VStack(spacing: 8) {
                ForEach(options) { option in
                    MultiSelectOptionView(
                        option: option,
                        isSelected: selectedOptions.contains(option.id)
                    ) {
                        if selectedOptions.contains(option.id) {
                            selectedOptions.remove(option.id)
                        } else {
                            selectedOptions.insert(option.id)
                        }
                    }
                }
            }
        }
    }
}

struct MultiSelectOptionView: View {
    let option: MultiSelectOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                // Option text
                Text(option.title)
                    .font(.system(size: 16, weight: .regular))
                    .lineSpacing(24 - 16)
                    .foregroundColor(Color(hex: "1F2937"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Selection indicator (only show when selected)
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "EA580C"))
                            .frame(width: 20, height: 20)
                        
                        // Checkmark icon
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 17)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(
                Group {
                    if isSelected {
                        // Selected state: light red background
                        Color(hex: "FFEBEB")
                    } else {
                        // Default state: white background
                        Color.white
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected ? Color(hex: "FFCACA") : Color(hex: "E5E7EB"),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MultiSelectListPreview()
}

struct MultiSelectListPreview: View {
    @State private var selectedOptions: Set<UUID> = []
    
    let sampleOptions = [
        MultiSelectOption(title: "I can correct most mistakes later if needed"),
        MultiSelectOption(title: "I can ask for help if I'm unsure"),
        MultiSelectOption(title: "Even 5 minutes of progress counts"),
        MultiSelectOption(title: "Avoiding this is increasing my stress"),
        MultiSelectOption(title: "I've handled similar documents before"),
        MultiSelectOption(title: "Done is better than perfect"),
        MultiSelectOption(title: "Your future self will thank you")
    ]
    
    var body: some View {
        VStack {
            MultiSelectList(
                options: sampleOptions,
                selectedOptions: $selectedOptions
            )
            .padding()
            
            // Debug info to show selected options
            VStack(alignment: .leading, spacing: 4) {
                Text("Selected options (\(selectedOptions.count)):")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                ForEach(sampleOptions) { option in
                    if selectedOptions.contains(option.id) {
                        Text("• \(option.title)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
    }
} 