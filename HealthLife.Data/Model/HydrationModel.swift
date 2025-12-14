//
//  HydrationData.swift
//  HealthLife
//
//  Created by Antonio Almeida on 30/11/25.
//

import SwiftData
import Foundation

@Model
final class HydrationModel {
    var date: Date
    var cupsWaterDrunk: Int
    var cupSize: Int

    init(date: Date, cupsWaterDrunk: Int, cupSize: Int) {
        self.date = date
        self.cupsWaterDrunk = cupsWaterDrunk
        self.cupSize = cupSize
    }
}
