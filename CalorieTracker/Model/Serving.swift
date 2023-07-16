//
//  Serving.swift
//  CalorieTracker
//
//  Created by Hongru on 7/11/23.
//

import Foundation

let unitTypeMapping: [ServingUnitType: [ServingUnit]] = [
    .mass: [.grams, .milligrams, .ounces, .pounds],
    .volume: [.milliliters, .liters, .fluidOunces],
]

enum ServingUnitType: String, Hashable, Codable {
    case mass
    case volume
    case all
    
    var allUnits: [ServingUnit] {
        switch self {
        case .all: ServingUnit.allCases
        default: unitTypeMapping[self]!
        }
    }
}

enum ServingUnit: String, Hashable, Codable, CaseIterable, Identifiable {
    case grams
    case milligrams
    case ounces
    case pounds
    case liters
    case milliliters
    case fluidOunces
    
    var dimension: Dimension {
        switch self {
        case .grams: UnitMass.grams
        case .milligrams: UnitMass.milligrams
        case .ounces: UnitMass.ounces
        case .pounds: UnitMass.pounds
        case .liters: UnitVolume.liters
        case .milliliters: UnitVolume.milliliters
        case .fluidOunces: UnitVolume.fluidOunces
        }
    }
    var type: ServingUnitType {
        for (type, units) in unitTypeMapping {
            if let _ = units.firstIndex(of: self) {
                return type
            }
        }
        return .mass // this should never be executed
    }
    var id: String { rawValue }
}


// ServingSize is essentially a wrapper around Measurement
// as unit in Measurement is a constant
struct Serving: Hashable, Codable {
    var value: Double
    var unit: ServingUnit
    
    var measurement: Measurement<Dimension> {
        Measurement(value: value, servingUnit: unit)
    }
    
    init(_ value: Double, unit: ServingUnit) {
        self.value = value
        self.unit = unit
    }
    
    var asString: String {
        "\(value.asTwoDecimalRoundedString) \(unit.dimension.symbol)"
    }
}

extension Serving {
    static func * (left: Serving, right: Double) -> Serving {
        Serving(left.value * right, unit: left.unit)
    }
    
    static func * (left: Double, right: Serving) -> Serving {
        right * left
    }
    
    static func / (left: Serving, right: Serving) -> Double? {
        guard left.unit.type == right.unit.type else {
            return nil
        }
        return left.measurement.converted(to: right.measurement.unit).value / right.measurement.value
    }
}

extension Serving {
    static var sampleData: Serving {
        Serving(100, unit: .grams)
    }
}
