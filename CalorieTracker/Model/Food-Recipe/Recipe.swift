//
//  Recipe.swift
//  CalorieTracker
//
//  Created by Hongru on 7/8/23.
//

import Foundation
import SwiftUI

struct Recipe<T: DiaryRecordable>: DiaryRecordable, Identifiable {
    let id: UUID
    var name: String
    let serving: Serving
    var components: [T: Serving]
    
    var category: String? = nil
    var imageName: String? = nil
    var description: String = ""

    var nutrition: Nutrition {
        var agg = Nutrition()
        for (food, unit) in components {
            agg += food.nutrition * (unit / food.serving)! // TODO: this may fail
        }
        return agg
    }
    var image: Image? {
        guard let imageName = imageName else {
            return nil
        }
        return Image(imageName)
    }
    init(id: UUID = UUID(), name: String, serving: Serving, components: [T: Serving], category: String? = nil, imageName: String? = nil, description: String = "") {
        self.id = id
        self.name = name
        self.serving = serving
        self.components = components
        self.category = category
        self.imageName = imageName
        self.description = description
    }
}

extension Recipe {
    static var sampleData: Recipe<Food> {
        Recipe<Food>(name: "DoubleMilk", serving: Serving.sampleData, components: [Food.sampleData[0]: Serving(200, unit: .grams), Food.sampleData[1]: Serving(100, unit: .grams)])
    }
}
