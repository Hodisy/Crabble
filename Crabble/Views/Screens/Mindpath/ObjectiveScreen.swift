import SwiftUI

struct ObjectiveScreen: View {
    @ObservedObject var navigationVM: MindpathNavigationViewModel
    @State private var selectedObjective: SelectListOption?
    @State private var customObjective: String = ""
    
    @State private var objectiveOptions = [
        SelectListOption(title: "Respond to the health insurance email"),
        SelectListOption(title: "Organize my student loan documents"),
        SelectListOption(title: "Upload proof of income for FAFSA"),
        SelectListOption(title: "Better sleep quality"),
        SelectListOption(title: "Tidy my desk before paperwork"),
        SelectListOption(title: "Draft personal statement for scholarship"),
        SelectListOption(title: "Check what documents are still missing"),
        SelectListOption(title: "Go for a 15-minute walk around campus"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Header section
                VStack(spacing: 24) {
                    // Top gradient square with target icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "2563EB"),
                                        Color(hex: "6187E5")
                                    ],
                                    startPoint: UnitPoint(x: 0, y: 0),
                                    endPoint: UnitPoint(x: 1, y: 1)
                                )
                            )
                            .frame(width: 64, height: 64)
                        
                        TargetIcon(outerSize: 26, middleSize: 16, innerSize: 5, color: .white)
                    }
                    
                    // Text content
                    VStack(spacing: 8) {
                        Text("Select Your Objective")
                            .font(.system(size: 24, weight: .bold))
                            .lineSpacing(32 - 24)
                            .foregroundColor(Color(hex: "1F2937"))
                            .multilineTextAlignment(.center)
                        
                        Text("What would you like to work on today?")
                            .font(.system(size: 16, weight: .regular))
                            .lineSpacing(24 - 16)
                            .foregroundColor(Color(hex: "4B5563"))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 24)

                // CrabbyThinks component
                CrabbyThinks(
                    bodyText: "I'm here to help you achieve your goals! Let's pick something meaningful to work on together.",
                    hasFixedSize: true,
                    maxLines: 3
                )
                .padding(.horizontal, 24)

                // SelectList
                SelectList(
                    title: "Choose your objective:",
                    options: objectiveOptions,
                    selectedOption: $selectedObjective
                )
                .padding(.horizontal, 24)

                // Input and actions section
                VStack(alignment: .leading, spacing: 16) {
                    // Label
                    Text("Add your own objective:")
                        .font(.system(size: 14, weight: .medium))
                        .lineSpacing(20 - 14)
                        .foregroundColor(Color(hex: "374151"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Input field with TextEditor
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                        
                        TextEditor(text: $customObjective)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(hex: "1F2937"))
                            .padding(.top, 12)
                            .padding(.leading, 12)
                            .padding(.trailing, 12)
                            .padding(.bottom, 12)
                            .background(Color.clear)
                            .scrollContentBackground(.hidden)
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                        
                        if customObjective.isEmpty {
                            Text("Type your custom objective...")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(hex: "9CA3AF"))
                                .padding(.top, 16)
                                .padding(.leading, 16)
                                .allowsHitTesting(false)
                        }
                    }
                    
                    // Add another task link
                    Button(action: {
                        addCustomObjective()
                    }) {
                        Text("+ Add another task")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "5544E5"))
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(PlainButtonStyle())
                    
                    // Start button
                    Button(action: {
                        if let selected = selectedObjective {
                            navigationVM.objective = selected.title
                        } else if !customObjective.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            navigationVM.objective = customObjective.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                        navigationVM.nextStep()
                    }) {
                        Text("Let's Start")
                            .font(.system(size: 18, weight: .medium))
                            .lineSpacing(28 - 18)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "4F46E5"),
                                        Color(hex: "9333EA")
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(navigationVM.currentStep == .objective && selectedObjective == nil && customObjective.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(navigationVM.currentStep == .objective && selectedObjective == nil && customObjective.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [
                            Color(hex: "F8FAFC"),
                            Color(hex: "F1F5F9")
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
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
    
    private func addCustomObjective() {
        let trimmedObjective = customObjective.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedObjective.isEmpty else { return }
        
        // Add the custom objective to the list
        let newObjective = SelectListOption(title: trimmedObjective)
        objectiveOptions.append(newObjective)
        
        // Select the newly added objective
        selectedObjective = newObjective
        
        // Clear the input field
        customObjective = ""
    }
}

#Preview {
    ObjectiveScreen(navigationVM: MindpathNavigationViewModel())
}
