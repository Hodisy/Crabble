import SwiftUI

struct TaskLocationSelector: View {
    @State private var selectedLocation: TaskLocationOption = .home
    @State private var customLocation: String = ""
    @State private var showCustomInput: Bool = false
    
    let onLocationSelected: (String) -> Void
    
    enum TaskLocationOption: String, CaseIterable {
        case home = "Home"
        case office = "Office"
        case cafe = "Café"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .home: return "house"
            case .office: return "building.2"
            case .cafe: return "cup.and.saucer"
            case .other: return "location"
            }
        }
    }
    
    init(onLocationSelected: @escaping (String) -> Void = { _ in }) {
        self.onLocationSelected = onLocationSelected
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Title
            HStack(spacing: 8) {
                Image(systemName: "location")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "374151"))
                
                Text("Where will you work on this?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "374151"))
            }
            
            // Predefined Location Options (2x2 Grid)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(TaskLocationOption.allCases, id: \.self) { option in
                    LocationButton(
                        option: option,
                        isSelected: selectedLocation == option,
                        onTap: {
                            selectedLocation = option
                            if option == .other {
                                showCustomInput = true
                            } else {
                                showCustomInput = false
                                customLocation = ""
                                onLocationSelected(option.rawValue)
                            }
                        }
                    )
                }
            }
            
            // Custom Location Input
            if showCustomInput {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add your own location:")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "374151"))
                    
                    TextField("On the balcony, library desk…", text: $customLocation)
                        .font(.system(size: 14, weight: .regular))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "D1D5DB"), lineWidth: 1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .onChange(of: customLocation) { oldValue, newValue in
                            if !newValue.isEmpty {
                                onLocationSelected(newValue)
                            }
                        }
                }
            }
            
            // Crabby's Suggestion
            CrabbySuggestionCard()
        }
    }
}

struct LocationButton: View {
    let option: TaskLocationSelector.TaskLocationOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: option.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? Color(hex: "1E40AF") : Color(hex: "6B7280"))
                
                Text(option.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? Color(hex: "1E40AF") : Color(hex: "374151"))
            }
            .frame(width: 170, height: 90)
            .background(isSelected ? Color(hex: "EFF6FF") : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Color(hex: "BFDBFE") : Color(hex: "E5E7EB"),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CrabbySuggestionCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text("CRABBY SUGGESTS")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color(hex: "581C87"))
                .tracking(0.5)
            
            // Description
            Text("A helpful spot for this kind of task:")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(hex: "6B21A8"))
            
            // Suggestion badge
            HStack {
                Text("+ Your usual desk")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "1E40AF"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(hex: "DBEAFE").opacity(0.7))
                    .clipShape(Capsule())
                
                Spacer()
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color(hex: "F3E8FF"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E9D5FF"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack(spacing: 20) {
        TaskLocationSelector { location in
            print("Selected location: \(location)")
        }
    }
    .padding()
    .background(Color.gray.opacity(0.1))
} 
