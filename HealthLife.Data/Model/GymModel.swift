//
//  GymData.swift
//  HealthLife
//
//  Created by Antonio Almeida on 06/12/25.
//

import SwiftData
import Foundation

@Model
final class GymModel {
    var date: Date
    var muscles: [String]

    init(date: Date, muscles: [String]) {
        self.date = date
        self.muscles = muscles
    }
}
