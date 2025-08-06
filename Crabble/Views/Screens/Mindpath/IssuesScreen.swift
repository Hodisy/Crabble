import SwiftUI

struct IssuesScreen: View {
    @ObservedObject var navigationVM: MindpathNavigationViewModel
    @State private var selectedOptions: Set<UUID> = []
    @State private var customConcern: String = ""

    @State private var concernOptions = [
        MultiSelectOption(title: "I don't know where to start"),
        MultiSelectOption(title: "It feels overwhelming"),
        MultiSelectOption(title: "I'm afraid of doing it wrong"),
        MultiSelectOption(title: "I don't have all the info"),
        MultiSelectOption(title: "What if I do it wrong?"),
        MultiSelectOption(title: "I don't have enough time"),
        MultiSelectOption(title: "I'm too tired right now"),
    ]

    init(navigationVM: MindpathNavigationViewModel) {
        self.navigationVM = navigationVM

        // Pre-select some items as specified
        let preSelectedTitles = [
            "I'm afraid of doing it wrong",
            "What if I do it wrong?",
            "I don't have enough time",
        ]

        for (_, option) in concernOptions.enumerated() {
            if preSelectedTitles.contains(option.title) {
                selectedOptions.insert(option.id)
            }
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Back button

                // Header section
                VStack(spacing: 24) {
                    // Top gradient square with cloud icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: "FEE0BD"),
                                        Color(hex: "FEDFDC"),
                                    ],
                                    startPoint: UnitPoint(x: 0, y: 0),
                                    endPoint: UnitPoint(x: 1, y: 1)
                                )
                            )
                            .frame(width: 64, height: 64)

                        Image(systemName: "cloud")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26, height: 26)
                            .foregroundColor(Color(hex: "EA580C"))
                    }

                    // Text content
                    VStack(spacing: 8) {
                        Text("Identify Potential Issues")
                            .font(.system(size: 24, weight: .bold))
                            .lineSpacing(32 - 24)
                            .foregroundColor(Color(hex: "1F2937"))
                            .multilineTextAlignment(.center)

                        Text("What might get in your way?")
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
                    bodyText: "It's normal to feel pressure… just starting is progress.",
                    hasFixedSize: true,
                    maxLines: 3
                )
                .padding(.horizontal, 24)

                // Smart suggestions InfoBox
                InfoBoxCard(
                    title: "Smart suggestions:",
                    subtitle: "Here are some common thoughts that make this feel harder:"
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

                // MultiSelectList for concerns
                MultiSelectList(
                    title: "Choose your concerns:",
                    options: concernOptions,
                    selectedOptions: $selectedOptions
                )
                .padding(.horizontal, 24)

                // Input and actions section
                VStack(alignment: .leading, spacing: 16) {
                    // Label
                    Text("Add your own concern:")
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

                        TextEditor(text: $customConcern)
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

                        if customConcern.isEmpty {
                            Text("I'll mess this up, I'm too late...")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(Color(hex: "9CA3AF"))
                                .padding(.top, 16)
                                .padding(.leading, 16)
                                .allowsHitTesting(false)
                        }
                    }

                    // Add another task link
                    Button(action: {
                        addCustomConcern()
                    }) {
                        Text("+ Add another task")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "7E22CE"))
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(PlainButtonStyle())

                    // Continue button
                    Button(action: {
                        // Save selected issues to navigation VM
                        let selectedIssues = concernOptions.filter { selectedOptions.contains($0.id) }.map { $0.title }
                        navigationVM.selectedIssues = Set(selectedIssues)
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

    private func addCustomConcern() {
        let trimmedConcern = customConcern.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedConcern.isEmpty else { return }

        // Add the custom concern to the list
        let newConcern = MultiSelectOption(title: trimmedConcern)
        concernOptions.append(newConcern)

        // Select the newly added concern
        selectedOptions.insert(newConcern.id)

        // Clear the input field
        customConcern = ""
    }
}

#Preview {
    IssuesScreen(navigationVM: MindpathNavigationViewModel())
}
