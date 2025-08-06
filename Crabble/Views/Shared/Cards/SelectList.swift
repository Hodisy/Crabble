import SwiftUI

struct SelectListOption: Identifiable {
    let id = UUID()
    let title: String
}

struct SelectList: View {
    let title: String
    let options: [SelectListOption]
    @Binding var selectedOption: SelectListOption?
    
    init(title: String = "Your Objective:", options: [SelectListOption], selectedOption: Binding<SelectListOption?>) {
        self.title = title
        self.options = options
        self._selectedOption = selectedOption
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
                    SelectListOptionView(
                        option: option,
                        isSelected: selectedOption?.id == option.id
                    ) {
                        selectedOption = option
                    }
                }
            }
        }
    }
}

struct SelectListOptionView: View {
    let option: SelectListOption
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
                
                // Validation circle (only show when selected)
                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "2563EB"))
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
                        // Selected state: gradient background
                        LinearGradient(
                            colors: [
                                Color(hex: "EFF6FF"),
                                Color(hex: "EEF2FF")
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        // Default state: white background
                        Color.white
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected ? Color(hex: "A8BDF2") : Color(hex: "E5E7EB"),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(
                color: isSelected ? Color.black.opacity(0.1) : Color.clear,
                radius: 2,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleOptions = [
        SelectListOption(title: "Improve focus and concentration"),
        SelectListOption(title: "Reduce stress and anxiety"),
        SelectListOption(title: "Enhance creativity"),
        SelectListOption(title: "Better sleep quality"),
        SelectListOption(title: "Increase productivity")
    ]
    
    return VStack {
        SelectListPreview()
    }
    .background(Color.gray.opacity(0.1))
}

struct SelectListPreview: View {
    @State private var selectedOption: SelectListOption?
    
    let sampleOptions = [
        SelectListOption(title: "Improve focus and concentration"),
        SelectListOption(title: "Reduce stress and anxiety"),
        SelectListOption(title: "Enhance creativity"),
        SelectListOption(title: "Better sleep quality"),
        SelectListOption(title: "Increase productivity")
    ]
    
    var body: some View {
        VStack {
            SelectList(
                options: sampleOptions,
                selectedOption: $selectedOption
            )
            .padding()
            
            // Debug info to show selected option
            if let selected = selectedOption {
                Text("Selected: \(selected.title)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                Text("No option selected")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
} 