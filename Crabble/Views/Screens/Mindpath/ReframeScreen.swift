import SwiftUI

struct ReframeScreen: View {
    @ObservedObject var navigationVM: MindpathNavigationViewModel
    @State private var selectedOptions: Set<UUID> = []
    @State private var customThought: String = ""

    @State private var reframeOptions = [
        MultiSelectOption(title: "I can correct most mistakes later if needed"),
        MultiSelectOption(title: "I can ask for help if I'm unsure"),
        MultiSelectOption(title: "Even 5 minutes of progress counts"),
        MultiSelectOption(title: "Avoiding this is increasing my stress"),
        MultiSelectOption(title: "I've handled similar documents before"),
        MultiSelectOption(title: "Done is better than perfect"),
        MultiSelectOption(title: "Your future self will thank you"),
    ]

    init(navigationVM: MindpathNavigationViewModel) {
        self.navigationVM = navigationVM

        // Pre-select some items as specified
        let preSelectedTitles = [
            "Even 5 minutes of progress counts",
            "I've handled similar documents before",
            "Done is better than perfect",
        ]

        for (_, option) in reframeOptions.enumerated() {
            if preSelectedTitles.contains(option.title) {
                selectedOptions.insert(option.id)
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Header section
                VStack(spacing: 24) {
                    // Top gradient square with lightbulb icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "FEF6D8"),
                                        Color(hex: "FDF8E2"),
                                    ],
                                    startPoint: UnitPoint(x: 0, y: 0),
                                    endPoint: UnitPoint(x: 1, y: 1)
                                )
                            )
                            .frame(width: 64, height: 64)

                        Image("LightIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color(hex: "F59E0B"))
                    }

                    // Text content
                    VStack(spacing: 8) {
                        Text("Reframe Your Thought")
                            .font(.system(size: 24, weight: .bold))
                            .lineSpacing(32 - 24)
                            .foregroundColor(Color(hex: "1F2937"))
                            .multilineTextAlignment(.center)

                        Text("Let's find a calmer perspective")
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
                    bodyText: "Mistakes are part of learning. Every step forward, no matter how small, builds your confidence and skills.",
                    hasFixedSize: true,
                    maxLines: 3
                )
                .padding(.horizontal, 24)

                // Smart suggestions InfoBox
                InfoBoxCard(
                    title: "Smart suggestions:",
                    subtitle: "These reframes might help you move forward with more ease:"
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

                // MultiSelectList
                MultiSelectList(
                    title: "Choose reframed thoughts:",
                    options: reframeOptions,
                    selectedOptions: $selectedOptions
                )
                .padding(.horizontal, 24)

                // Input and actions section
                VStack(alignment: .leading, spacing: 16) {
                    // Label
                    Text("Add your own reframed thought:")
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

                        TextEditor(text: $customThought)
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

                        if customThought.isEmpty {
                            Text("I can start small, I've done this before...")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(hex: "9CA3AF"))
                                .padding(.top, 16)
                                .padding(.leading, 16)
                                .allowsHitTesting(false)
                        }
                    }

                    // Add another task link
                    Button(action: {
                        addCustomThought()
                    }) {
                        Text("+ Add another task")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "7E22CE"))
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(PlainButtonStyle())

                    // Continue button
                    Button(action: {
                        // Save selected reframes to navigation VM
                        let selectedReframes = reframeOptions.filter { selectedOptions.contains($0.id) }.map { $0.title }
                        navigationVM.selectedReframes = Set(selectedReframes)
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
                    .disabled(selectedOptions.isEmpty)
                    .opacity(selectedOptions.isEmpty ? 0.6 : 1.0)
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
    }

    private func addCustomThought() {
        let trimmedThought = customThought.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedThought.isEmpty else { return }

        // Add the custom thought to the list
        let newThought = MultiSelectOption(title: trimmedThought)
        reframeOptions.append(newThought)

        // Select the newly added thought
        selectedOptions.insert(newThought.id)

        // Clear the input field
        customThought = ""
    }
}

#Preview {
    ReframeScreen(navigationVM: MindpathNavigationViewModel())
}
