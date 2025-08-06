import SwiftUI

struct PlanScreen: View {
    @ObservedObject var navigationVM: MindpathNavigationViewModel
    @State private var selectedReminderMethod: String = "Just plan for now"

    let reminderMethods = ["Add to calendar", "Set a reminder", "Just plan for now"]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header section
                VStack(spacing: 24) {
                    // Top gradient square with calendar icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "D1FAE5"),
                                        Color(hex: "E0F2FE"),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 64, height: 64)

                        Image("CalendarIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color(hex: "10B981"))
                    }

                    // Text content
                    VStack(spacing: 8) {
                        Text("Plan this step")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(hex: "1F2937"))
                            .multilineTextAlignment(.center)

                        Text("When and where will you work on this?")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(Color(hex: "4B5563"))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 24)

                // Objective Pill
                HStack(spacing: 8) {
                    TargetIcon(size: 16, color: Color(hex: "7E22CE"))

                    Text("Upload proof of income for FAFSA")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "7E22CE"))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(hex: "FAF5FF"))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(hex: "E9D5FF"), lineWidth: 1)
                )
                .clipShape(Capsule())
                .padding(.horizontal, 24)

                // CrabbyThinks component
                CrabbyThinks(
                    bodyText: "Right after breakfast, sit at your desk with a warm tea. Take a breath, open the tab — just one step.",
                    hasFixedSize: true,
                    maxLines: 3
                )
                .padding(.horizontal, 24)

                // Current Step Box
                TaskStepBox(
                    currentTask: "Open your FAFSA email",
                    currentStep: 1,
                    totalSteps: 4,
                    showSecondaryAction: true
                )
                .padding(.horizontal, 24)

                // Smart Suggestions Card
                TaskSuggestionsCard(
                    onRegenerate: {
                        print("Regenerating suggestions...")
                    }
                )
                .padding(.horizontal, 24)

                // Location Selector
                TaskLocationSelector { location in
                    print("Selected location: \(location)")
                }
                .padding(.horizontal, 24)

                // Time Scheduler
                TaskTimeScheduler(
                    onLaunchNow: {
                        print("Launching now...")
                    },
                    onScheduleFor: { date in
                        print("Scheduled for: \(date)")
                    },
                    onSuggestionSelected: { suggestion in
                        print("Selected time suggestion: \(suggestion)")
                    }
                )
                .padding(.horizontal, 24)

                // Environment Preparation
                TaskEnvironmentPreparation(
                    onEnvironmentChanged: { text in
                        print("Environment text: \(text)")
                    },
                    onSuggestionSelected: { suggestion in
                        print("Selected environment suggestion: \(suggestion)")
                    }
                )
                .padding(.horizontal, 24)

                // Focus Mode Selector
                TaskFocusModeSelector { focusMode in
                    print("Selected focus mode: \(focusMode.rawValue)")
                }
                .padding(.horizontal, 24)

                // Reminder Method Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Reminder Method")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "1F2937"))
                        .padding(.horizontal, 24)

                    VStack(spacing: 8) {
                        ForEach(reminderMethods, id: \.self) { method in
                            Button(action: {
                                selectedReminderMethod = method
                            }) {
                                HStack {
                                    if selectedReminderMethod == method {
                                        Image("CheckIcon")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(Color(hex: "10B981"))
                                    } else {
                                        Circle()
                                            .stroke(Color(hex: "D1D5DB"), lineWidth: 1)
                                            .frame(width: 16, height: 16)
                                    }

                                    Text(method)
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(Color(hex: "1F2937"))

                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedReminderMethod == method ? Color(hex: "F0FDF4") : Color.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            selectedReminderMethod == method ? Color(hex: "10B981") : Color(hex: "E5E7EB"),
                                            lineWidth: 1
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                }

                // CTA Footer
                VStack(spacing: 16) {
                    Button(action: {
                        // Save plan details and return to main screen
                        navigationVM.planDetails["reminderMethod"] = selectedReminderMethod
                        navigationVM.nextStep() // This will set isActive to false and return to main screen
                    }) {
                        Text("Complete Session")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 352, height: 56)
                            .background(Color(hex: "10B981"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        // Return to main screen without saving
                        navigationVM.nextStep()
                    }) {
                        Text("Skip and plan later")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "0D9488"))
                            .underline()
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "E0E7FF"),
                    Color(hex: "F3E8FF"),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

#Preview {
    PlanScreen(navigationVM: MindpathNavigationViewModel())
}
