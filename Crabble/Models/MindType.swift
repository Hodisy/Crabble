import Foundation

enum MindType: String, CaseIterable {
    case adhd = "ADHD & Executive Function"
    case anxiety = "Anxiety & Overwhelm"
    
    var subtitle: String {
        switch self {
        case .adhd:
            return "Lots of ideas, trouble prioritizing, need help breaking things down and staying focused"
        case .anxiety:
            return "Tasks feel overwhelming, perfectionism gets in the way, need structure and gentle guidance"
        }
    }
} 