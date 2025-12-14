//
//  GymHistoryView.swift
//  HealthLife
//
//  Created by Antonio Almeida on 06/12/25.
//
import SwiftUI
import SwiftData

struct GymHistoryView: View {

    @Environment(\.modelContext) private var modelContext

    // Fetch all gym records, newest first
    @Query(sort: [SortDescriptor(\GymModel.date, order: .reverse)])
    private var records: [GymModel]

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
                    "No gym records",
                    systemImage: "dumbbell.fill",
                    description: Text("Your saved workouts will appear here.")
                )
            } else {
                Section {
                    ForEach(records, id: \.self) { item in
                        let muscles = item.muscles.compactMap { GymView.Muscle(rawValue: $0)?.displayName }
                        let musclesText = muscles.isEmpty ? "No muscles selected" : muscles.joined(separator: ", ")

                        NavigationLink {
                            GymView(record: item)
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    let dateText = dateFormatter.string(from: item.date)
                                    let weekdayText = weekdayFormatter.string(from: item.date)
                                    Text("\(dateText) - \(weekdayText)")
                                        .font(.headline)

                                    Text(musclesText)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 6)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(
                            Text("\(dateFormatter.string(from: item.date)) \(weekdayFormatter.string(from: item.date)), \(musclesText)")
                        )
                    }
                }
            }
        }
        .navigationTitle("Gym History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Gym History") {
    NavigationStack {
        GymHistoryView()
    }
    .modelContainer(for: [GymModel.self], inMemory: true)
}
