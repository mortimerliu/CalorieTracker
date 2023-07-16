//
//  DiaryRecord.swift
//  CalorieTracker
//
//  Created by Hongru on 7/9/23.
//

import Foundation

enum MealType: String, Hashable, Codable, CaseIterable, Identifiable {
    case breakfast
    case lunch
    case dinner
    case breakfastExtra
    case lunchExtra
    case dinnerExtra
    
    var id: String { rawValue }
}

// <T: DiaryRecordable>
struct DiaryRecord: Hashable, Codable, Identifiable {
    typealias T = Food
    let id: UUID
    var food: T
    // var date: Date
    var serving: Serving // this has to be of the same ServingUnitType as food.servingSize
    // var mealType: MealType
    
    var nutrition: Nutrition {
        food.nutrition * (serving / food.serving)!
    }
//    var dateString: String {
//        date.formatted(.dateTime.day().month().year())
//    }
    
    init(id: UUID = UUID(), food: T, serving: Serving) {
        self.id = id
        self.food = food
        // self.date = date
        // self.mealType = mealType
        self.serving = serving
    }
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    static func == (lhs: DiaryRecord, rhs: DiaryRecord) -> Bool {
//        return lhs.id == rhs.id
//    }
}

extension DiaryRecord {
    static let sampleData: [DiaryRecord] = [
        DiaryRecord(food: Food.sampleData[0], serving: Serving(3, unit:Food.sampleData[0].serving.unit)),
        DiaryRecord(food: Food.sampleData[1], serving: Serving(200, unit:Food.sampleData[1].serving.unit))
    ]
    static let sampleDiaryData: [String: [MealType: [DiaryRecord]]] = [
        Date().dateString: [.breakfast: sampleData]
    ]
}

//struct Meal: Hashable, Codable, Identifiable {
//    let id: UUID
//    var dishes: [DiaryRecord]
//}
