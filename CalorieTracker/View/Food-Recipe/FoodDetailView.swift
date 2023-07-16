//
//  ProductList.swift
//  CalorieTracker
//
//  Created by Hongru on 7/8/23.
//

import SwiftUI

struct FoodDetailView: View {
    // @Environment(FoodStore.self) private var foodStore
    @EnvironmentObject var foodStore: FoodStore
    var food: Food
    @State private var draftFood: Food = Food.emptyFood
    @State private var isEditing = false
    
    private var foodIndex: Int {
        foodStore.stock.firstIndex(where: { $0.id == food.id })!
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                (food.image ?? Image("default-placeholder-300x300_3"))
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 150)
                HStack {
                    Text(food.name)
                        .font(.title)
                        .bold()
                    // FavoriteButton(isSet: $isFavorite)
                }
                .padding(.leading, 20)
            }
            List {
                Section(header: Text("Basic Info")) {
                    Label(food.description == "" ? "None" : food.description, systemImage: "text.bubble")
                    HStack {
                        Label("Serving Size", systemImage: "textformat.size")
                        Spacer()
                        Text(food.serving.asString)
                    }
                    HStack {
                        Label("Serving Size Type", systemImage: "textformat.size")
                        Spacer()
                        Text(food.serving.unit.type.rawValue.capitalized)
                    }
                    if let category = food.category {
                        HStack {
                            Label("Category", systemImage: "square.grid.2x2")
                            Spacer()
                            Text(category)
                        }
                    }
                }
                Section(header: Text("Nutrition Facts")) {
                    NutritionTableView(nutrition: food.nutrition)
                }
            }
        }
        //.navigationTitle(food.name)
        .toolbar {
            Button("Edit") {
                isEditing = true
                draftFood = food
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                FoodEditView(food: $draftFood, servingUnitType: food.serving.unit.type)
                    .navigationTitle(food.name)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isEditing = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isEditing = false
                                foodStore.updateFood(draftFood)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        FoodDetailView(food: Food.sampleData[0])
            .environmentObject(FoodStore.shared)
    }
}
