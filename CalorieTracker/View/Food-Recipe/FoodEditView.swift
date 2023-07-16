//
//  AddFoodView.swift
//  CalorieTracker
//
//  Created by Hongru on 7/9/23.
//

import SwiftUI

struct FoodEditView: View {
    @Binding var food: Food
    var servingUnitType: ServingUnitType
    
    var body: some View {
        Form {
            Section(header: Text("Basic Info")) {
                HStack {
                    Text("Food Name")
                    TextField("Food name", text: $food.name)
                        .multilineTextAlignment(.trailing)
                }
                VStack(alignment: .leading) {
                    Text("Description")
                    TextField(food.description, text: $food.description, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.leading)
                }
                HStack {
                    Text("Serving Size")
                    TextField("100", value: $food.serving.value, formatter: NumberFormatter())
                        .multilineTextAlignment(.trailing)
                }
                Picker("Serving Unit", selection: $food.serving.unit) {
                    ForEach(servingUnitType.allUnits) { unit in
                        Text(unit.dimension.symbol).tag(unit)
                    }
                }
                
            }
            Section(header: Text("Nutrition Facts")) {
                List {
                    ForEach($food.nutrition) { $item in
                        VStack {
                            HStack {
                                Text(item.type.rawValue.capitalized)
                                TextField("100", value: $item.value, formatter: NumberFormatter())
                                    .multilineTextAlignment(.trailing)
                            }
                            Picker("", selection: $item.unit) {
                                ForEach(item.type.nutritionUnitChoices) { unit in
                                    Text(unit.dimension.symbol).tag(unit)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FoodEditView(food: .constant(Food.emptyFood), servingUnitType: .all)
}
