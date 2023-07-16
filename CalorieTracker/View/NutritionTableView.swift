//
//  NutritionTable.swift
//  CalorieTracker
//
//  Created by Hongru on 7/8/23.
//

import SwiftUI

struct NutritionRowView: View {
    var item: NutritionItem
    
    var body: some View {
        HStack {
            Text(item.type.rawValue.capitalized)
            Spacer()
            Text(item.asString)
        }
    }
}

struct NutritionTableView: View {
    var nutrition: Nutrition
    
    var body: some View {
        ForEach(nutrition) { item in
            NutritionRowView(item: item)
        }
    }
}

#Preview {
    NutritionTableView(nutrition: Food.sampleData[0].nutrition)
}
