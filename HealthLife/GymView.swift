//
//  GymView.swift
//  HealthLife
//
//  Created by Antonio Almeida on 02/12/25.
//

import SwiftUI
import SwiftData

struct GymView: View {

    @Environment(\.modelContext) private var modelContext
    private var repository: GymRepository { DefaultGymRepository(modelContext: modelContext) }
    var record: GymModel?

    private var headerDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }

    enum Muscle: String, CaseIterable, Identifiable, Hashable {
        case chest, back, traps, shoulders, biceps, triceps
        case abs
        case legs, calves
        case cardio

        var id: String { rawValue }

        var displayName: String {
            rawValue
                .replacingOccurrences(of: "Abs", with: "Abs")
                .splitBeforeUppercase()
                .capitalizedWords()
        }
    }

    @State private var selectedMuscles: Set<Muscle> = []

    var body: some View {
        VStack(spacing: 24) {
            MuscleSelectionGrid(
                allMuscles: Muscle.allCases,
                selected: selectedMuscles,
                toggle: { muscle in
                    if selectedMuscles.contains(muscle) {
                        selectedMuscles.remove(muscle)
                    } else {
                        selectedMuscles.insert(muscle)
                    }
                    saveSelection()
                }
            )

            if record == nil {
                NavigationLink {
                    GymHistoryView()
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
            }
        }
        .padding(.horizontal, 24)
        .navigationTitle(headerTitleDateString)
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
            let saved = Set(record.muscles.compactMap { Muscle(rawValue: $0) })
            selectedMuscles = saved
        } else {
            loadTodayIfExists()
        }
    }

    private func loadTodayIfExists() {
        do {
            if let todayRecord = try repository.fetchTodayRecord() {
                let saved = Set(todayRecord.muscles.compactMap { Muscle(rawValue: $0) })
                selectedMuscles = saved
            }
        } catch {
            print("Failed to load today's gym entry: \(error)")
        }
    }

    private func saveSelection() {
        do {
            let rawValues = selectedMuscles.map { $0.rawValue }.sorted()
            if let record {
                try repository.update(record: record, withMuscles: rawValues)
            } else {
                try repository.upsertToday(muscles: rawValues)
            }
        } catch {
            print("Failed to save gym selection: \(error)")
        }
    }
}
