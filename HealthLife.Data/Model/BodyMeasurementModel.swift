//
//  MeasurementData.swift
//  HealthLife
//
//  Created by Antonio Almeida on 08/12/25.
//

import SwiftData
import Foundation

@Model
final class BodyMeasurementModel {
    var date: Date
    
    var chest: Float?
    var belly: Float?
    var leftArm: Float?
    var rightArm: Float?
    var leftLeg: Float?
    var rightLeg: Float?
    var weight: Float?

    init(
        date: Date,
        chest: Float? = nil,
        belly: Float? = nil,
        leftArm: Float? = nil,
        rightArm: Float? = nil,
        leftLeg: Float? = nil,
        rightLeg: Float? = nil,
        weight: Float? = nil
    ) {
        self.date = date
        self.chest = chest
        self.belly = belly
        self.leftArm = leftArm
        self.rightArm = rightArm
        self.leftLeg = leftLeg
        self.rightLeg = rightLeg
        self.weight = weight
    }
}
