import SwiftUI

struct TargetIcon: View {
    let size: CGFloat
    let color: Color
    let outerSize: CGFloat?
    let middleSize: CGFloat?
    let innerSize: CGFloat?
    
    // Default initializer for existing usage
    init(size: CGFloat, color: Color) {
        self.size = size
        self.color = color
        self.outerSize = nil
        self.middleSize = nil
        self.innerSize = nil
    }
    
    // Custom initializer for specific circle sizes
    init(outerSize: CGFloat, middleSize: CGFloat, innerSize: CGFloat, color: Color) {
        self.size = outerSize
        self.color = color
        self.outerSize = outerSize
        self.middleSize = middleSize
        self.innerSize = innerSize
    }
    
    var body: some View {
        ZStack {
            // Outer circle
            Circle()
                .stroke(color, lineWidth: 1.5)
                .frame(width: outerSize ?? size, height: outerSize ?? size)
            
            // Middle circle
            Circle()
                .stroke(color, lineWidth: 1.5)
                .frame(width: middleSize ?? (size * 0.65), height: middleSize ?? (size * 0.65))
            
            // Inner circle
            Circle()
                .stroke(color, lineWidth: 1.5)
                .frame(width: innerSize ?? (size * 0.3), height: innerSize ?? (size * 0.3))
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        TargetIcon(size: 16, color: .white)
            .padding()
            .background(Color.blue)
        
        TargetIcon(outerSize: 26, middleSize: 16, innerSize: 5, color: .white)
            .padding()
            .background(Color.blue)
    }
} 