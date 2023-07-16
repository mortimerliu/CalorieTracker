//
//  Food.swift
//  CalorieTracker
//
//  Created by Hongru on 7/7/23.
//

import Foundation
import SwiftUI
import Observation

struct Food: DiaryRecordable, Identifiable {
    let id: UUID
    var name: String = "New Food"
    var serving: Serving = Serving(100, unit: .grams)
    var nutrition: Nutrition = Nutrition()
    
    var imageName: String? = nil
    var description: String = ""
    var category: String? = nil
    var image: Image? {
        guard let imageName = imageName else {
            return nil
        }
        return Image(imageName)
    }
    var isFavorite = false
    
    init(id: UUID = UUID(), name: String, serving: Serving, nutrition: Nutrition, imageName: String? = nil, description: String = "", category: String? = nil) {
        self.id = id
        self.name = name
        self.serving = serving
        self.nutrition = nutrition
        self.imageName = imageName
        self.description = description
        self.category = category
    }
}

extension Food {
    static let sampleData: [Food] = [
        Food(name: "Milk", serving: Serving.sampleData, nutrition: Nutrition.sampleData, description: "This is Milk. This is Milk. This is Milk. This is Milk. This is Milk. This is Milk. This is Milk. This is Milk.", category: "Milk"),
        Food(name: "Juice", serving: Serving.sampleData, nutrition: Nutrition.sampleData)
     ]
    
    static var emptyFood: Food {
        Food(name: "", serving: Serving(100, unit: .grams), nutrition: Nutrition.emptyNutrition)
    }
}
