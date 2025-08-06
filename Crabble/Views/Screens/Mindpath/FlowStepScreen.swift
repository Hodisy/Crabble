import SwiftUI

struct FlowStepScreen: View {
    @ObservedObject var navigationVM: MindpathNavigationViewModel
    @State private var customTask: String = ""
    @State private var steps: [Item] = [
        Item(text: "Open your FAFSA email"),
        Item(text: "Check missing documents"),
        Item(text: "Take a picture of your income"),
        Item(text: "Upload the document"),
    ]

    // Check if Gemma 3n model is available


    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Header section
                VStack(spacing: 24) {
                    // Top gradient square with check icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "FBDFF4"),
                                        Color(hex: "FDF1F8"),
                                    ],
                                    startPoint: UnitPoint(x: 0, y: 0),
                                    endPoint: UnitPoint(x: 1, y: 1)
                                )
                            )
                            .frame(width: 64, height: 64)

                        Image("CheckIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color(hex: "DB2777"))
                    }

                    // Text content
                    VStack(spacing: 8) {
                        Text("Break into small tasks")
                            .font(.system(size: 24, weight: .bold))
                            .lineSpacing(32 - 24)
                            .foregroundColor(Color(hex: "1F2937"))
                            .multilineTextAlignment(.center)

                        Text("Break it down to move forward")
                            .font(.system(size: 16, weight: .regular))
                            .lineSpacing(24 - 16)
                            .foregroundColor(Color(hex: "4B5563"))
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 24)

                // Pill tag
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
                    bodyText: "Breaking big tasks into smaller steps makes them feel more manageable. Each small step is a victory that builds momentum.",
                    hasFixedSize: true,
                    maxLines: 3,
                    suggestions: [
                        "Break this down further",
                        "Add more specific steps",
                        "Consider potential obstacles",
                    ],
                    context: "User is working on breaking down FAFSA application tasks into smaller, manageable steps. They have a list of tasks like opening emails, checking documents, taking pictures, and uploading files.",
                    promptType: .taskBreakdown
                )
                .padding(.horizontal, 24)

                // Smart suggestions InfoBox
                InfoBoxCard(
                    title: "Smart suggestions:",
                    subtitle: "This objective can feel lighter when broken down like this:"
                )
                .padding(.horizontal, 24)

                // Regenerate link
                Button(action: {
                    print("Regenerate tapped")
                }) {
                    HStack(spacing: 6) {
                        Image("SparkleIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 14, height: 14)
                            .foregroundColor(Color(hex: "7E22CE"))

                        Text("Regenerate")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "7E22CE"))
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 24)

                // DraggableList
                DraggableList(items: $steps)
                    .padding(.horizontal, 24)

                // Input and actions section
                VStack(alignment: .leading, spacing: 16) {
                    // Label
                    Text("Add your own small task:")
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

                        TextEditor(text: $customTask)
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

                        if customTask.isEmpty {
                            Text("Find the email, list needed documents...")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(hex: "71717A"))
                                .padding(.top, 16)
                                .padding(.leading, 16)
                                .allowsHitTesting(false)
                        }
                    }

                    // Add another task link
                    Button(action: {
                        addCustomTask()
                    }) {
                        Text("+ Add another task")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "7E22CE"))
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(PlainButtonStyle())

                    // Continue button
                    Button(action: {
                        // Save flow steps to navigation VM
                        navigationVM.flowSteps = steps.map { $0.text }
                        navigationVM.nextStep()
                    }) {
                        Text("Continue")
                            .font(.system(size: 18, weight: .medium))
                            .lineSpacing(28 - 18)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "4F46E5"),
                                        Color(hex: "9333EA"),
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(steps.isEmpty)
                    .opacity(steps.isEmpty ? 0.6 : 1.0)
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: [
                            Color(hex: "F8FAFC"),
                            Color(hex: "F1F5F9"),
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
                .onAppear {
            // Model availability check removed - using only Gemma 3n
        }
    }

    private func addCustomTask() {
        let trimmedTask = customTask.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTask.isEmpty else { return }

        // Add the custom task to the list
        let newTask = Item(text: trimmedTask)
        steps.append(newTask)

        // Clear the input field
        customTask = ""
    }
}

#Preview {
    FlowStepScreen(navigationVM: MindpathNavigationViewModel())
}
