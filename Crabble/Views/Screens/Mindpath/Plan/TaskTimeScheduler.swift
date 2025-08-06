import SwiftUI

struct TaskTimeScheduler: View {
    @State private var selectedDate = Date()
    @State private var showDatePicker = false

    let onLaunchNow: () -> Void
    let onScheduleFor: (Date) -> Void
    let onSuggestionSelected: (String) -> Void

    init(
        onLaunchNow: @escaping () -> Void = {},
        onScheduleFor: @escaping (Date) -> Void = { _ in },
        onSuggestionSelected: @escaping (String) -> Void = { _ in }
    ) {
        self.onLaunchNow = onLaunchNow
        self.onScheduleFor = onScheduleFor
        self.onSuggestionSelected = onSuggestionSelected
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Title
            HStack(spacing: 8) {
                Image(systemName: "clock")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "374151"))

                Text("When will you do this?")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "374151"))
            }

            // Launch Now Button
            Button(action: onLaunchNow) {
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "374151"))

                    Text("Launch Now")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "374151"))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "E5E7EB"), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(PlainButtonStyle())

            // Separator
            HStack {
                Rectangle()
                    .fill(Color(hex: "E5E7EB"))
                    .frame(height: 1)

                Text("or")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "9CA3AF"))
                    .padding(.horizontal, 16)

                Rectangle()
                    .fill(Color(hex: "E5E7EB"))
                    .frame(height: 1)
            }

            // Schedule for Later
            VStack(alignment: .leading, spacing: 8) {
                Text("Schedule for later")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(hex: "374151"))

                Button(action: {
                    showDatePicker = true
                }) {
                    HStack {
                        Text(formatDate(selectedDate))
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(hex: "374151"))

                        Spacer()

                        Image(systemName: "calendar")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color(hex: "6B7280"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "D1D5DB"), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(PlainButtonStyle())
            }

            // Crabby's Suggestions
            CrabbyTimeSuggestionsCard(onSuggestionSelected: onSuggestionSelected)
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerSheet(
                selectedDate: $selectedDate,
                onDateSelected: { date in
                    selectedDate = date
                    onScheduleFor(date)
                    showDatePicker = false
                }
            )
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy, HH:mm"
        return formatter.string(from: date)
    }
}

struct CrabbyTimeSuggestionsCard: View {
    let onSuggestionSelected: (String) -> Void

    let timeSuggestions = [
        "Late morning focus block",
        "After lunch reset",
        "Just before dinner",
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text("CRABBY SUGGESTS")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color(hex: "581C87"))
                .tracking(0.5)

            // Description
            Text("A time to usually handle things like this:")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(hex: "6B21A8"))

            // Suggestion buttons
            VStack(spacing: 8) {
                ForEach(timeSuggestions, id: \.self) { suggestion in
                    Button(action: {
                        onSuggestionSelected(suggestion)
                    }) {
                        HStack {
                            Text("+ \(suggestion)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "581C87"))

                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(hex: "E9D5FF").opacity(0.7))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color(hex: "F3E8FF"))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E9D5FF"), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    let onDateSelected: (Date) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            DatePicker(
                "Select Date & Time",
                selection: $selectedDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()

            Button("Confirm") {
                onDateSelected(selectedDate)
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(hex: "1E40AF"))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .navigationTitle("Schedule Task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        TaskTimeScheduler(
            onLaunchNow: {
                print("Launching now...")
            },
            onScheduleFor: { date in
                print("Scheduled for: \(date)")
            },
            onSuggestionSelected: { suggestion in
                print("Selected suggestion: \(suggestion)")
            }
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
