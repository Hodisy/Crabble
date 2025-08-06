import SwiftUI

struct TaskStepBox: View {
    let currentTask: String
    let currentStep: Int
    let totalSteps: Int
    let showSecondaryAction: Bool
    let secondaryActionText: String

    init(
        currentTask: String,
        currentStep: Int,
        totalSteps: Int,
        showSecondaryAction: Bool = false,
        secondaryActionText: String = "Use previous task setup"
    ) {
        self.currentTask = currentTask
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.showSecondaryAction = showSecondaryAction
        self.secondaryActionText = secondaryActionText
    }

    var body: some View {
        VStack(spacing: 0) {
            // Main card
            VStack {
                // Left side content
                HStack(alignment: .center, spacing: 8) {
                    // Header
                    Text("Current step:")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "064E3B"))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    // Step indicator badge
                    Text("Step \(currentStep) of \(totalSteps)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: "047857"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: "D1FAE5"))
                        .clipShape(Capsule())

                    // Main task text
                }

                Text(currentTask)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "1F2937"))
                    .lineSpacing(24 - 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "ECFDF5"))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "D1FAE5"), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Secondary action (optional)
            if showSecondaryAction {
                HStack(spacing: 8) {
                    Image("PlainPuzzleIcon")
                        .resizable()
                        .foregroundColor(Color(hex: "28BD84"))
                        .frame(width: 12, height: 12)

                    Text(secondaryActionText)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "28BD84"))
                }
                .padding(.top, 12)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        // Example with secondary action
        TaskStepBox(
            currentTask: "Open your FAFSA email",
            currentStep: 1,
            totalSteps: 4,
            showSecondaryAction: true
        )
        
        // Example without secondary action
        TaskStepBox(
            currentTask: "Complete your profile information",
            currentStep: 2,
            totalSteps: 4
        )
        
        // Example with longer task text
        TaskStepBox(
            currentTask: "Review and submit your application for the scholarship program",
            currentStep: 3,
            totalSteps: 5,
            showSecondaryAction: true,
            secondaryActionText: "Use saved application data"
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
