import SwiftUI

enum MindpathStep: CaseIterable {
    case objective
    case issues
    case reframe
    case flowStep
    case plan
    
    var title: String {
        switch self {
        case .objective:
            return "Objective"
        case .issues:
            return "Issues"
        case .reframe:
            return "Reframe"
        case .flowStep:
            return "Flow Step"
        case .plan:
            return "Plan"
        }
    }
    
    var index: Int {
        switch self {
        case .objective:
            return 0
        case .issues:
            return 1
        case .reframe:
            return 2
        case .flowStep:
            return 3
        case .plan:
            return 4
        }
    }
}

class MindpathNavigationViewModel: ObservableObject {
    @Published var currentStep: MindpathStep = .objective
    @Published var isActive: Bool = true
    
    // Data for each step
    @Published var objective: String = ""
    @Published var selectedIssues: Set<String> = []
    @Published var selectedReframes: Set<String> = []
    @Published var flowSteps: [String] = []
    @Published var planDetails: [String: Any] = [:]
    
    var progress: Double {
        let currentIndex = currentStep.index
        let totalSteps = MindpathStep.allCases.count
        return Double(currentIndex + 1) / Double(totalSteps)
    }
    
    var canGoNext: Bool {
        switch currentStep {
        case .objective:
            return !objective.isEmpty
        case .issues:
            return !selectedIssues.isEmpty
        case .reframe:
            return !selectedReframes.isEmpty
        case .flowStep:
            return !flowSteps.isEmpty
        case .plan:
            return true // Plan can always proceed
        }
    }
    
    func nextStep() {
        guard canGoNext else { return }
        
        switch currentStep {
        case .objective:
            currentStep = .issues
        case .issues:
            currentStep = .reframe
        case .reframe:
            currentStep = .flowStep
        case .flowStep:
            currentStep = .plan
        case .plan:
            // Return to main screen
            isActive = false
        }
    }
    
    func previousStep() {
        switch currentStep {
        case .objective:
            // Go back to main screen
            isActive = false
        case .issues:
            currentStep = .objective
        case .reframe:
            currentStep = .issues
        case .flowStep:
            currentStep = .reframe
        case .plan:
            currentStep = .flowStep
        }
    }
    
    func reset() {
        currentStep = .objective
        objective = ""
        selectedIssues.removeAll()
        selectedReframes.removeAll()
        flowSteps.removeAll()
        planDetails.removeAll()
    }
}
