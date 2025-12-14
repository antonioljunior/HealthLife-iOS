//
//  BodyMeasurementsView.swift
//  HealthLife
//
//  Created by Antonio Almeida on 08/12/25.
//

import SwiftUI
import SwiftData
import UserNotifications

struct BodyMeasurementsView: View {

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    // Optional existing record to edit (when coming from history)
    var record: BodyMeasurementModel?

    // Local state for each required Float field
    @State private var chestText: String = ""
    @State private var bellyText: String = ""
    @State private var leftArmText: String = ""
    @State private var rightArmText: String = ""
    @State private var leftLegText: String = ""
    @State private var rightLegText: String = ""
    @State private var weightText: String = ""

    // Alerts and navigation state
    @State private var showSuccessAlert: Bool = false
    @State private var showValidationAlert: Bool = false
    @State private var navigateToHistory: Bool = false

    private var headerDateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .none
        return f
    }

    // All fields required
    private var isFormValid: Bool {
        parsedFloatOrNil(chestText) != nil &&
        parsedFloatOrNil(bellyText) != nil &&
        parsedFloatOrNil(leftArmText) != nil &&
        parsedFloatOrNil(rightArmText) != nil &&
        parsedFloatOrNil(leftLegText) != nil &&
        parsedFloatOrNil(rightLegText) != nil &&
        parsedFloatOrNil(weightText) != nil
    }

    var body: some View {
        VStack(spacing: 24) {
            // Programmatic navigation to History after save (new record)
            NavigationLink(
                destination: BodyMeasurementsHistoryView(),
                isActive: $navigateToHistory
            ) { EmptyView() }
            .hidden()

            Form {
                Section(header: Text("Body Measurements")) {
                    MeasurementFieldRow(title: "Chest", text: $chestText, unit: "cm")
                    MeasurementFieldRow(title: "Belly", text: $bellyText, unit: "cm")
                    MeasurementFieldRow(title: "Left Arm", text: $leftArmText, unit: "cm")
                    MeasurementFieldRow(title: "Right Arm", text: $rightArmText, unit: "cm")
                    MeasurementFieldRow(title: "Left Leg", text: $leftLegText, unit: "cm")
                    MeasurementFieldRow(title: "Right Leg", text: $rightLegText, unit: "cm")
                    MeasurementFieldRow(title: "Weight", text: $weightText, unit: "kg")
                }

                Section {
                    Button {
                        if isFormValid {
                            saveMeasurements()
                        } else {
                            showValidationAlert = true
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Save")
                                .font(.headline)
                            Spacer()
                        }
                    }
                    .disabled(!isFormValid)
                    .accessibilityIdentifier("save_body_measurements_button")
                }
            }

            // Only show "View History" when this screen is not in editing mode
            if record == nil {
                NavigationLink {
                    BodyMeasurementsHistoryView()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.headline)
                        Text("View History")
                            .font(.headline)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(Color.primary.opacity(0.25), lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color.primary.opacity(0.06))
                            )
                    )
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("view_body_measurements_history_button")
            }
        }
        .padding(.horizontal, 16)
        .navigationTitle(headerTitleDateString)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            initializeState()
        }
        .alert("Your Measurements has been recorded!", isPresented: $showSuccessAlert) {
            Button("OK") {
                if record == nil {
                    // New record: go to History
                    navigateToHistory = true
                } else {
                    // Editing: pop back to History
                    dismiss()
                }
            }
        }
        .alert("Please fill in all fields", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("All fields are required and must be valid numbers.")
        }
    }

    private var headerTitleDateString: String {
        if let record {
            return headerDateFormatter.string(from: record.date)
        } else {
            return headerDateFormatter.string(from: Date())
        }
    }

    // MARK: - Initialization
    private func initializeState() {
        if let record {
            chestText = formatFloat(record.chest)
            bellyText = formatFloat(record.belly)
            leftArmText = formatFloat(record.leftArm)
            rightArmText = formatFloat(record.rightArm)
            leftLegText = formatFloat(record.leftLeg)
            rightLegText = formatFloat(record.rightLeg)
            weightText = formatFloat(record.weight)
        } else {
            loadTodayIfExists()
        }
    }

    private func formatFloat(_ value: Float?) -> String {
        guard let value else { return "" }
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
        }

    private func scheduleReminderNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Body Measurement Reminder"
        content.body = "Don't forget to log your body measurements today!"
        content.sound = .default

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["bodyMeasurementReminder"])

        let interval: TimeInterval = 60 * 60 * 24 * 30
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: "bodyMeasurementReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error { print("Error adding notification request: \(error)") }
        }
    }

    private func todayStart() -> Date {
        Calendar.current.startOfDay(for: Date())
    }

    private func fetchTodayRecord() throws -> BodyMeasurementModel? {
        let start = todayStart()
        guard let end = Calendar.current.date(byAdding: .day, value: 1, to: start) else { return nil }

        var descriptor = FetchDescriptor<BodyMeasurementModel>(
            predicate: #Predicate { item in
                item.date >= start && item.date < end
            }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func loadTodayIfExists() {
        do {
            if let todayRecord = try fetchTodayRecord() {
                chestText = formatFloat(todayRecord.chest)
                bellyText = formatFloat(todayRecord.belly)
                leftArmText = formatFloat(todayRecord.leftArm)
                rightArmText = formatFloat(todayRecord.rightArm)
                leftLegText = formatFloat(todayRecord.leftLeg)
                rightLegText = formatFloat(todayRecord.rightLeg)
                weightText = formatFloat(todayRecord.weight)
            }
        } catch {
            print("Failed to load today's body measurements: \(error)")
        }
    }

    private func saveMeasurements() {
        guard isFormValid else {
            showValidationAlert = true
            return
        }

        let chest = parsedFloatOrNil(chestText)!
        let belly = parsedFloatOrNil(bellyText)!
        let leftArm = parsedFloatOrNil(leftArmText)!
        let rightArm = parsedFloatOrNil(rightArmText)!
        let leftLeg = parsedFloatOrNil(leftLegText)!
        let rightLeg = parsedFloatOrNil(rightLegText)!
        let weight = parsedFloatOrNil(weightText)!

        do {
            if let record {
                record.chest = chest
                record.belly = belly
                record.leftArm = leftArm
                record.rightArm = rightArm
                record.leftLeg = leftLeg
                record.rightLeg = rightLeg
                record.weight = weight
            } else {
                if let todayRecord = try fetchTodayRecord() {
                    todayRecord.chest = chest
                    todayRecord.belly = belly
                    todayRecord.leftArm = leftArm
                    todayRecord.rightArm = rightArm
                    todayRecord.leftLeg = leftLeg
                    todayRecord.rightLeg = rightLeg
                    todayRecord.weight = weight
                } else {
                    let entry = BodyMeasurementModel(
                        date: todayStart(),
                        chest: chest,
                        belly: belly,
                        leftArm: leftArm,
                        rightArm: rightArm,
                        leftLeg: leftLeg,
                        rightLeg: rightLeg,
                        weight: weight
                    )
                    modelContext.insert(entry)
                }
            }
            scheduleReminderNotification()
            showSuccessAlert = true
        } catch {
            print("Failed to save body measurements: \(error)")
        }
    }

    private func parsedFloatOrNil(_ text: String) -> Float? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: trimmed) {
            return number.floatValue
        }
        return Float(trimmed)
    }

    private func parseFloat(from text: String) -> Float? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .decimal
        if let number = formatter.number(from: trimmed) {
            return number.floatValue
        }
        return Float(trimmed)
    }
}

// MARK: - Subviews
private struct MeasurementFieldRow: View {
    let title: String
    @Binding var text: String
    let unit: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            HStack(spacing: 8) {
                TextField("0", text: $text)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(minWidth: 60)
                Text(unit)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) in \(unit)")
        .accessibilityValue(text.isEmpty ? "not set" : text)
    }
}

#Preview("Body Measurements") {
    NavigationStack {
        BodyMeasurementsView()
    }
    .modelContainer(for: [BodyMeasurementModel.self], inMemory: true)
}
