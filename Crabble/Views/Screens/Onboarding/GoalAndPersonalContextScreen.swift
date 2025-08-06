import SwiftUI

struct GoalAndPersonalContextScreen: View {
    let onNext: () -> Void
    @State private var isPersonalContextExpanded = false
    @State private var isGoalsExpanded = false
    @State private var personalContextText = ""
    @State private var goalsText = ""
    @State private var objectiveText = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Title and Subtitle
                VStack(spacing: 16) {
                    Text("Let's get started")
                        .font(.system(size: 24, weight: .bold))
                        .lineSpacing(32 - 24)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: "#1F2937"))
                        .padding(.horizontal, 24)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Share as much or as little as you'd like. Everything is optional except your first objective")
                        .font(.system(size: 14, weight: .regular))
                        .lineSpacing(24 - 16)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: "#4B5563"))
                        .padding(.horizontal, 24)
                        .fixedSize(horizontal: false, vertical: true)
                }.padding(.top, 24)

                // Collapsible Boxes
                VStack(spacing: 16) {
                    // Personal Context Box
                    CollapsibleBox(
                        title: "Personal context (optional)",
                        isExpanded: $isPersonalContextExpanded,
                        text: $personalContextText,
                        placeholder: "A few words about your challenges, mindset or routines (e.g. anxiety, ADHD, stress at school, work struggles…)"
                    )

                    // Goals & Organization Box
                    CollapsibleBox(
                        title: "Goals & organization (optional)",
                        isExpanded: $isGoalsExpanded,
                        text: $goalsText,
                        placeholder: "What would you like help with? (e.g. forms, deadlines, routines) — how do you usually plan things?"
                    )
                }
                .padding(.horizontal, 24)

                // Objective Box
                VStack(spacing: 16) {
                    // Header with icon and title
                    HStack(alignment: .top, spacing: 12) {
                        Image("BrainIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(hex: "#E449A4"))
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(hex: "#FABDF0"),
                                                Color(hex: "#F9DCE6"),
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )

                        Text("Your first objective:")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "#1F2937"))

                        Spacer()
                    }

                    // Input and random button
                    HStack(spacing: 12) {
                        TextField("placeholder...", text: $objectiveText)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(hex: "#1F2937"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                            )

                        Button(action: {
                            // Random action
                        }) {
                            Image("DiceIcon")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color(hex: "#E449A4"))
                                .frame(width: 32, height: 32)
                                .background(Color(hex: "#F3E8FF"))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "#E9D5FF"), lineWidth: 1)
                                )
                                .cornerRadius(12)
                        }
                    }

                    // Suggestions section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("From your calendar:")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(hex: "#1F2937"))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        VStack(spacing: 8) {
                            SuggestionButton(
                                icon: "CalendarIcon",
                                text: "Prepare for 2pm meeting with Sarah"
                            )

                            SuggestionButton(
                                icon: "CalendarIcon",
                                text: "Review presentation slides"
                            )

                            SuggestionButton(
                                icon: "CalendarIcon",
                                text: "Finish quarterly report draft"
                            )

                            SuggestionButton(
                                icon: "CalendarIcon",
                                text: "Call dentist to reschedule"
                            )
                        }
                    }
                }
                .padding(16)
                .background(Color.white.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                )
                .cornerRadius(12)
                .padding(.horizontal, 24)

             
                // Add another objective button
                Button(action: {
                    // Add another objective action
                }) {
                    Text("+ Add another objective")
                        .font(.system(size: 14, weight: .regular))
                        .lineSpacing(20 - 14)
                        .foregroundColor(Color(hex: "#E449A4"))
                }
                .buttonStyle(PlainButtonStyle())

                // Your other objectives section
                // VStack(alignment: .leading, spacing: 12) {
                //     Text("Your other objectives:")
                //         .font(.system(size: 16, weight: .medium))
                //         .lineSpacing(24 - 16)
                //         .foregroundColor(Color(hex: "#1F2937"))
                //         .frame(maxWidth: .infinity, alignment: .leading)

                //     VStack(spacing: 8) {
                //         ObjectiveListItem(
                //             title: "Finish quarterly report draft",
                //             onDelete: {
                //                 // Delete action
                //             }
                //         )

                //         ObjectiveListItem(
                //             title: "Call Clara",
                //             onDelete: {
                //                 // Delete action
                //             }
                //         )
                //     }
                // }
                // .padding(.horizontal, 24)
                Spacer()
                // Continue Button
                Button(action: onNext) {
                    Text("Continue")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: "#EFF6FF"),
                    Color(hex: "#FAF5FF"),
                    Color(hex: "#FDF2F8"),
                ],
                startPoint: UnitPoint(x: 0, y: 0),
                endPoint: UnitPoint(x: 1, y: 1)
            )
        )
    }
}

struct CollapsibleBox: View {
    let title: String
    @Binding var isExpanded: Bool
    @Binding var text: String
    let placeholder: String

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(hex: "#1F2937"))

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? "- Hide" : "+ Show")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#E449A4"))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // Content
            if isExpanded {
                VStack(spacing: 12) {
                    TextEditor(text: $text)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color(hex: "#1F2937"))
                        .frame(minHeight: 80)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#AAD7DE"), lineWidth: 1)
                        )
                        .overlay(
                            Group {
                                if text.isEmpty {
                                    Text(placeholder)
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(Color(hex: "#71717A"))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 16)
                                        .allowsHitTesting(false)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                }
                            }
                        )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.white.opacity(0.6))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

struct SuggestionButton: View {
    let icon: String
    let text: String

    var body: some View {
        Button(action: {
            // Handle suggestion selection
        }) {
            HStack(spacing: 12) {
                Image(icon)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color(hex: "#E449A4"))

                Text(text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(hex: "#1F2937"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ObjectiveListItem: View {
    let title: String
    let onDelete: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(hex: "#1F2937"))
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onDelete) {
                Image("CloseIcon")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(Color(hex: "#E449A4"))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

#Preview {
    GoalAndPersonalContextScreen(onNext: {})
}
