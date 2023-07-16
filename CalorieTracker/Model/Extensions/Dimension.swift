//
//  Dimension.swift
//  CalorieTracker
//
//  Created by Hongru on 7/10/23.
//

import Foundation

extension Measurement where UnitType: Dimension {
    init(value: Double, servingUnit:ServingUnit) {
        self.init(value: value, unit: servingUnit.dimension as! UnitType)
    }
}
