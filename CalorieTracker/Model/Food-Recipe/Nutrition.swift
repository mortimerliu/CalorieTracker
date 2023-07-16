//
//  NutritionFactRecordable.swift
//  CalorieTracker
//
//  Created by Hongru on 7/8/23.
//

import Foundation

enum NutritionUnit: String, Hashable, Codable, CaseIterable, Identifiable {
    case grams
    case milligrams
    case kcal
    case kj
    
    var dimension: Dimension {
        switch self {
        case .grams: UnitMass.grams
        case .milligrams: UnitMass.milligrams
        case .kcal: UnitEnergy.kilocalories
        case .kj: UnitEnergy.kilojoules
        }
    }
    
    var id: String { rawValue }
}

enum NutritionType: String, CaseIterable, Codable, Comparable, Identifiable {
    static func < (lhs: NutritionType, rhs: NutritionType) -> Bool {
        lhs.index < rhs.index
    }
    
    case calorie
    case fat
    case protein
    case carbohydrate
    case sugar
    case sodium
    
    var defaultUnit: NutritionUnit {
        switch self {
        case .calorie: NutritionUnit.kcal
        default: NutritionUnit.grams
        }
    }
    
    var nutritionUnitChoices: [NutritionUnit] {
        switch self {
        case .calorie: [.kcal, .kj]
        default: [.grams, .milligrams]
        }
    }
    
    var index: Int {
        NutritionType.allCases.firstIndex(of: self)!
    }
    
    var id: String { rawValue }
}

struct NutritionItem: Hashable, Codable, Identifiable {
    var type: NutritionType
    var value: Double
    var unit: NutritionUnit
    
    var measurement: Measurement<Dimension> {
        Measurement(value: value, unit: unit.dimension)
    }
    
    init(type: NutritionType, value: Double, unit: NutritionUnit? = nil) {
        self.type = type
        self.value = value
        self.unit = unit ?? type.defaultUnit
    }
    
    var id: NutritionType { type }
    
    var asString: String {
        "\(value.asTwoDecimalRoundedString) \(unit.dimension.symbol)"
    }
}

extension NutritionItem {
    static func + (left: NutritionItem, right: NutritionItem) -> NutritionItem? {
        guard left.type == right.type else {
            return nil
        }
        let total = left.measurement.converted(to: right.measurement.unit) + right.measurement
        return NutritionItem(type: left.type, value: total.value, unit: right.unit)
    }
    
    static func * (left: NutritionItem, right: Double) -> NutritionItem {
        NutritionItem(type: left.type, value: left.value * right, unit: left.unit)
    }
}

// Nutrition is a collection of NutritionItem
struct Nutrition: Hashable, Codable {
    typealias DictionaryType = [NutritionType: NutritionItem]
    
    private var values: DictionaryType = [:]
    private var items: [NutritionItem] {
        Array(values.values).sorted { $0.type < $1.type }
    } // TODO: make this a private stored property for performance
    var allTypes: Set<NutritionType> {
        Set(values.keys)
    }
    
    init(_ values: NutritionItem...) {
        for value in values {
            self.values[value.type] = value
        }
    }
    
    subscript(index: NutritionType) -> NutritionItem {
        get {
            guard let value = values[index] else {
                return NutritionItem(type: index, value: 0)
            }
            return value
        }
        set(newValue) {
            values[index] = newValue
        }
    }
}

extension Nutrition: RandomAccessCollection, MutableCollection {
    typealias Index = Int
    typealias Element = NutritionItem
    
    var startIndex: Index { return items.startIndex }
    var endIndex: Index { return items.endIndex }
    
    subscript(position: Index) -> Element {
        get {
            items[position]
        }
        set {
            values[items[position].type] = newValue
        }
    }
    
    func index(after i: Index) -> Index {
        return items.index(after: i)
    }
    
    func index(before i: Index) -> Index {
        return items.index(before: i)
    }
}

extension Nutrition {
    static func + (left: Nutrition, right: Nutrition) -> Nutrition {
        var res = Nutrition()
        for type in left.allTypes.union(right.allTypes) {
            let left_res = left[type]
            let right_res = right[type]
            res[type] = (left_res + right_res)!
        }
        return res
    }
    
    static func += (left: inout Nutrition, right: Nutrition) {
        left = left + right
    }
    
    static func * (left: Nutrition, right: Double) -> Nutrition {
        var res = Nutrition()
        for item in left {
            res[item.type] = item * right
        }
        return res
    }
    
    static func * (left: Double, right: Nutrition) -> Nutrition {
        right * left
    }
}

extension Nutrition {
    static var sampleData: Nutrition {
        Nutrition(
            NutritionItem(type: .calorie, value: 100),
            NutritionItem(type: .fat, value: 10),
            NutritionItem(type: .protein, value: 10),
            NutritionItem(type: .carbohydrate, value: 30)
        )
    }
    
    static var emptyNutrition: Nutrition {
        var nutrition = Nutrition()
        for type in NutritionType.allCases {
            nutrition[type] = NutritionItem(type: type, value: 0)
        }
        return nutrition
    }
}
