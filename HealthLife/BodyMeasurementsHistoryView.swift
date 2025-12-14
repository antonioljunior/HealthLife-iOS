//
//  BodyMeasurementsHistoryView.swift
//  HealthLife
//
//  Created by Antonio Almeida on 08/12/25.
//

import SwiftUI
import SwiftData

struct BodyMeasurementsHistoryView: View {

    @Environment(\.modelContext) private var modelContext

    // Fetch all body measurement records, newest first
    @Query(sort: [SortDescriptor(\BodyMeasurementModel.date, order: .reverse)])
    private var records: [BodyMeasurementModel]

    @State private var showConfirmDelete: Bool = false
    @State private var pendingDeleteOffsets: IndexSet?

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }

    private var weekdayFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        return f
    }

    var body: some View {
        List {
            if records.isEmpty {
                ContentUnavailableView(
                    "No body measurement records",
                    systemImage: "figure.arms.open",
                    description: Text("Your saved body measurements will appear here.")
                )
            } else {
                Section {
                    ForEach(records, id: \.self) { item in
                        let summary = summaryText(for: item)

                        NavigationLink {
                            BodyMeasurementsView(record: item)
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    let dateText = dateFormatter.string(from: item.date)
                                    let weekdayText = weekdayFormatter.string(from: item.date)
                                    Text("\(dateText) - \(weekdayText)")
                                        .font(.headline)

                                    Text(summary)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 6)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(
                            Text("\(dateFormatter.string(from: item.date)) \(weekdayFormatter.string(from: item.date)), \(summary)")
                        )
                    }
                    .onDelete { offsets in
                        pendingDeleteOffsets = offsets
                        showConfirmDelete = true
                    }
                }
            }
        }
        .navigationTitle("Body Measurements History")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete record?", isPresented: $showConfirmDelete, presenting: pendingDeleteOffsets) { offsets in
            Button("Delete", role: .destructive) {
                performDeletion(using: offsets)
                pendingDeleteOffsets = nil
            }
            Button("Cancel", role: .cancel) {
                pendingDeleteOffsets = nil
            }
        } message: { offsets in
            // If multiple rows are selected via edit mode (not shown), this still works.
            let count = offsets.count
            Text(count == 1 ? "This action cannot be undone." : "Delete \(count) records? This action cannot be undone.")
        }
    }

    private func performDeletion(using offsets: IndexSet) {
        for index in offsets {
            guard records.indices.contains(index) else { continue }
            let item = records[index]
            modelContext.delete(item)
        }
    }

    private func summaryText(for item: BodyMeasurementModel) -> String {
        var parts: [String] = []
        func addCm(_ label: String, _ value: Float?) {
            if let v = value {
                parts.append("\(label): \(format(v)) cm\n")
            }
        }
        func addKg(_ label: String, _ value: Float?) {
            if let v = value {
                parts.append("\(label): \(format(v)) kg\n")
            }
        }
        // Order: Weight first (often most important), then body parts
        addKg("Weight", item.weight)
        addCm("Chest", item.chest)
        addCm("Belly", item.belly)
        addCm("Left Arm", item.leftArm)
        addCm("Right Arm", item.rightArm)
        addCm("Left Leg", item.leftLeg)
        addCm("Right Leg", item.rightLeg)
        return parts.isEmpty ? "No measurements" : parts.joined(separator: "")
    }

    private func format(_ v: Float) -> String {
        let nf = NumberFormatter()
        nf.locale = .current
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        return nf.string(from: NSNumber(value: v)) ?? String(v)
    }
}

#Preview("Without Data") {
    NavigationStack {
        BodyMeasurementsHistoryView()
    }
    // Pass model types as variadic, and use the inMemory convenience flag
    .modelContainer(for: BodyMeasurementModel.self, inMemory: true)
}
