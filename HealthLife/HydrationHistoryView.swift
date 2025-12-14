//
//  HydrationHistory.swift
//  HealthLife
//
//  Created by Antonio Almeida on 30/11/25.
//

import SwiftUI
import SwiftData

struct HydrationHistoryView: View {

    @Environment(\.modelContext) private var modelContext

    // Fetch all hydration records, newest first
    @Query(sort: [SortDescriptor(\HydrationModel.date, order: .reverse)])
    private var records: [HydrationModel]
    private let dailyGoal: Int = 9

    // Date formatters for date and weekday, using current locale
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }

    private var weekdayFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "EEEE" // full weekday name, localized
        return f
    }

    var body: some View {
        List {
            if records.isEmpty {
                ContentUnavailableView(
                    "No hydration records",
                    systemImage: "drop.triangle",
                    description: Text("Your saved hydration entries will appear here.")
                )
            } else {
                Section {
                    ForEach(records, id: \.self) { item in
                        let metGoal = item.cupsWaterDrunk >= dailyGoal
                        NavigationLink {
                            HydrationView(record: item)
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    // Example: "3 Dec 2025 - Wednesday"
                                    let dateText = dateFormatter.string(from: item.date)
                                    let weekdayText = weekdayFormatter.string(from: item.date)
                                    Text("\(dateText) - \(weekdayText)")
                                        .font(.headline)

                                    Text("\(item.cupsWaterDrunk) cups • \(item.cupSize) ml")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    Text("Total: \(item.cupsWaterDrunk * item.cupSize) ml")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 6)
                        }
                        .listRowBackground(
                            (metGoal ? Color.green : Color.red).opacity(0.15)
                        )
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(
                            Text("\(dateFormatter.string(from: item.date)) \(weekdayFormatter.string(from: item.date)), \(item.cupsWaterDrunk) cups, total \(item.cupsWaterDrunk * item.cupSize) milliliters, \(metGoal ? "goal met" : "goal not met")")
                        )
                    }
                }
            }
        }
        .navigationTitle("Hydration History")
        .navigationBarTitleDisplayMode(.inline)
//        .onAppear() {
//            runOneTimeCupSizeMigrationIfNeeded(newSize: 450)
//        }
    }
    
//    private func runOneTimeCupSizeMigrationIfNeeded(newSize: Int) {
//        let key = "didSetAllCupSizesTo\(newSize)"
//        guard !UserDefaults.standard.bool(forKey: key) else { return }
//
//        do {
//            var descriptor = FetchDescriptor<HydrationData>()
//            // Only update those not already the target size
//            descriptor.predicate = #Predicate { $0.cupSize != newSize }
//
//            let items = try modelContext.fetch(descriptor)
//            for item in items {
//                item.cupSize = newSize
//            }
//
//            // Optional explicit save
//            try modelContext.save()
//
//            UserDefaults.standard.set(true, forKey: key)
//        } catch {
//            print("Migration to set cup size failed: \(error)")
//        }
//    }
}

#Preview("Hydration History") {
    NavigationStack {
        HydrationHistoryView()
    }
    .modelContainer(for: HydrationModel.self, inMemory: true)
}

