//
//  GymRepository.swift
//  HealthLife
//
//  Created by Antonio Almeida on 13/12/25.
//

import Foundation
import SwiftData

protocol GymRepository {
    func fetchTodayRecord() throws -> GymModel?
    func fetchAllSorted() throws -> [GymModel]
    func upsertToday(muscles: [String]) throws
    func update(record: GymModel, withMuscles muscles: [String]) throws
    func delete(_ record: GymModel) throws
}

final class DefaultGymRepository: GymRepository {
    private let modelContext: ModelContext
    private let calendar: Calendar

    init(modelContext: ModelContext, calendar: Calendar = .current) {
        self.modelContext = modelContext
        self.calendar = calendar
    }

    // MARK: - Helpers

    private func startOfToday() -> Date {
        calendar.startOfDay(for: Date())
    }

    private func startAndEndOfToday() -> (start: Date, end: Date)? {
        let start = startOfToday()
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else {
            return nil
        }
        return (start, end)
    }

    // MARK: - Queries
    func fetchTodayRecord() throws -> GymModel? {
        guard let (start, end) = startAndEndOfToday() else { return nil }
        var descriptor = FetchDescriptor<GymModel>(
            predicate: #Predicate { item in
                item.date >= start && item.date < end
            }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    func fetchAllSorted() throws -> [GymModel] {
        var descriptor = FetchDescriptor<GymModel>()
        descriptor.sortBy = [SortDescriptor(\GymModel.date, order: .reverse)]
        return try modelContext.fetch(descriptor)
    }

    // MARK: - Mutations
    func upsertToday(muscles: [String]) throws {
        if let today = try fetchTodayRecord() {
            today.muscles = muscles
        } else {
            let entry = GymModel(date: startOfToday(), muscles: muscles)
            modelContext.insert(entry)
        }
    }

    func update(record: GymModel, withMuscles muscles: [String]) throws {
        record.muscles = muscles
    }

    func delete(_ record: GymModel) throws {
        modelContext.delete(record)
    }
}
