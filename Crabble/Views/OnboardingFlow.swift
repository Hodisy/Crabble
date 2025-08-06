import SwiftUI

struct OnboardingFlow: View {
    @State private var step: Int = 0
    
    var body: some View {
        NavigationStack {
            switch step {
            case 0:
                WelcomeScreen(onNext: { step += 1 })
            case 1:
                GemmaBenefitsScreen(onNext: { step += 1 })
            case 2:
                MindSupportScreen(onNext: { step += 1 })
            case 3:
                GoalAndPersonalContextScreen(onNext: { step += 1 })
            case 4:
                ConnectAppsScreen(onNext: { step += 1 })
            case 5:
                MainScreen()
                
            default:
                EmptyView()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    OnboardingFlow()
} 
