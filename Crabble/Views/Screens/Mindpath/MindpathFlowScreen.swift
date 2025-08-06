import SwiftUI

struct MindpathFlowScreen: View {
    @StateObject private var navigationVM = MindpathNavigationViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Group {
                switch navigationVM.currentStep {
                case .objective:
                    ObjectiveScreen(navigationVM: navigationVM)
                case .issues:
                    IssuesScreen(navigationVM: navigationVM)
                case .reframe:
                    ReframeScreen(navigationVM: navigationVM)
                case .flowStep:
                    FlowStepScreen(navigationVM: navigationVM)
                case .plan:
                    PlanScreen(navigationVM: navigationVM)
                }
            }
            .navigationBarHidden(true)
            .onChange(of: navigationVM.isActive) { isActive in
                if !isActive {
                    dismiss()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MindpathFlowScreen()
}
