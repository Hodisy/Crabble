import SwiftUI

struct MindJourneyCard: View {
    @State private var progressWidth: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with title and badge
            HStack {
                Text("Your Mind's Journey")
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                    .lineSpacing(24 - 16)
                    .foregroundColor(Color(hex: "1F2937"))
                
                Spacer()
                
                // Completion badge
                HStack(spacing: 4) {
                    Text("2/3 completed")
                        .font(.system(size: 12, weight: .semibold))
                        .lineSpacing(16 - 12)
                        .foregroundColor(Color(hex: "15803D"))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color(hex: "DCFCE7"))
                .clipShape(Capsule())
                .frame(height: 22)
            }
            
            // Progress bar
            VStack(alignment: .leading, spacing: 8) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 4)
                            .cornerRadius(2)
                        
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: progressWidth, height: 4)
                            .cornerRadius(2)
                            .animation(.easeInOut(duration: 1.2), value: progressWidth)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            progressWidth = geometry.size.width * 0.75
                        }
                    }
                }
                .frame(height: 4)
            }
            
            // Metrics badges
            HStack {
                // Left side metrics
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 4) {
                        Image("PlainCircleIcon")
                            .resizable()
                            .foregroundColor(Color(hex: "22C55E"))
                            .frame(width: 12, height: 12)
                        
                        Text("12 active days")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "1F2937"))
                    }
                    
                    HStack(spacing: 4) {
                        Image("PlainHeartIcon")
                            .resizable()
                            .foregroundColor(Color(hex: "F56565"))
                            .frame(width: 12, height: 12)
                        
                        Text("Energized")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "1F2937"))
                    }
                }
                
                Spacer().frame(width: 68)
                
                // Right side metrics
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 4) {
                        Image("UpIcon")
                            .resizable()
                            .foregroundColor(Color(hex: "3B82F6"))
                            .frame(width: 12, height: 12)
                        
                        Text("3h45m focus")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "1F2937"))
                    }
                    
                    HStack(spacing: 4) {
                        Image("PlainStarIcon")
                            .resizable()
                            .foregroundColor(Color(hex: "EAB308"))
                            .frame(width: 12, height: 12)
                        
                        Text("Consistent effort")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "1F2937"))
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    MindJourneyCard()
        .padding()
        .background(Color.gray.opacity(0.1))
} 
