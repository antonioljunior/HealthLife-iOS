//
//  HidtrationView.swift
//  HealthLife
//
//  Created by Antonio Almeida on 29/11/25.
//

import SwiftUI
import SwiftData

struct HydrationView: View {

    @Environment(\.modelContext) private var modelContext

    // Optional existing record to edit (when coming from history)
    var record: HydrationModel?

    @State private var cupsDrank: Int = 0
    @State private var cupSizeML: Int = 450

    private let maxCupsWaterPerDay: Int = 11
    private let dailyGoal: Int = 10

    private var headerDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }

    private var progress: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(1.0, max(0.0, Double(cupsDrank) / Double(dailyGoal)))
    }

    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer(minLength: 0)

                // Content block centered vertically
                VStack(spacing: 24) {
                    // Jar progress visualization
                    JarProgressView(progress: progress)
                        .frame(width: 200, height: 280)
                        .accessibilityLabel("Water jar")
                        .accessibilityValue("\(Int(progress * 100)) percent filled")

                    // Summary
                    VStack(spacing: 6) {
                        Text("Today: \(cupsDrank) / \(dailyGoal) cups")
                            .font(.title2).bold()
                        Text("Total: \(cupsDrank * cupSizeML) ml • Cup: \(cupSizeML) ml")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Controls
                    HStack(spacing: 36) {
                        Button {
                            if cupsDrank > 0 {
                                cupsDrank -= 1
                                saveHydration()
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 48, weight: .semibold))
                                .foregroundColor(cupsDrank == 0 ? .gray : .red)
                        }
                        .disabled(cupsDrank == 0)

                        Button {
                            if cupsDrank < maxCupsWaterPerDay {
                                cupsDrank += 1
                                saveHydration()
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 48, weight: .semibold))
                                .foregroundColor(cupsDrank == maxCupsWaterPerDay ? .gray : .green)
                        }
                        .disabled(cupsDrank == maxCupsWaterPerDay)
                    }

                    // Navigation to history - show only when not editing
                    if record == nil {
                        NavigationLink {
                            HydrationHistoryView()
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
                        .padding(.top, 2)
                        .accessibilityIdentifier("view_history_button")
                    }
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: 480)

                Spacer(minLength: 0)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .navigationTitle("Your today's water intake")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            initializeState()
        }
    }

    private var headerTitleDateString: String {
        if let record {
            return headerDateFormatter.string(from: record.date)
        } else {
            return headerDateFormatter.string(from: Date())
        }
    }

    private func initializeState() {
        if let record {
            // Editing an existing record
            cupsDrank = record.cupsWaterDrunk
            cupSizeML = record.cupSize
        } else {
            // Default behavior: load today's record if it exists
            loadTodayIfExists()
        }
    }

    private func saveHydration() {
        do {
            if let record {
                // Update the provided record directly
                record.cupsWaterDrunk = cupsDrank
                record.cupSize = cupSizeML
            } else {
                // Original "today" behavior
                if let todayRecord = try fetchTodayRecord() {
                    todayRecord.cupsWaterDrunk = cupsDrank
                    todayRecord.cupSize = cupSizeML
                } else {
                    let entry = HydrationModel(
                        date: todayStart(),
                        cupsWaterDrunk: cupsDrank,
                        cupSize: cupSizeML
                    )
                    modelContext.insert(entry)
                }
            }
        } catch {
            print("Failed to save hydration entry: \(error)")
        }
    }

    private func loadTodayIfExists() {
        do {
            if let todayRecord = try fetchTodayRecord() {
                cupsDrank = todayRecord.cupsWaterDrunk
                cupSizeML = todayRecord.cupSize
            }
        } catch {
            print("Failed to load today's hydration entry: \(error)")
        }
    }

    private func todayStart() -> Date {
        Calendar.current.startOfDay(for: Date())
    }

    private func fetchTodayRecord() throws -> HydrationModel? {
        let start = todayStart()
        guard let end = Calendar.current.date(byAdding: .day, value: 1, to: start) else {
            return nil
        }

        var descriptor = FetchDescriptor<HydrationModel>(
            predicate: #Predicate { item in
                item.date >= start && item.date < end
            }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }
}

#Preview("Hydration") {
    HydrationView()
        .modelContainer(for: HydrationModel.self, inMemory: true)
}
