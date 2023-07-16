//
//  FoodList.swift
//  CalorieTracker
//
//  Created by Hongru on 7/9/23.
//

import SwiftUI

struct FoodListView<Destination: View>: View {
    //@Environment(FoodStore.self) private var foodStore
    @EnvironmentObject var foodStore: FoodStore
    // SwiftUI indicates the current operational state of your app’s Scene instances with a scenePhase Environment value.
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: () -> Void
    @State private var onlyFavorite = false
    @State private var newFood: Food = Food.emptyFood
    @State private var isAdding = false
    
    var destination: (Food) -> Destination
    
    private var filteredFoods: [Food] {
        foodStore.stock.filter { food in
            (!onlyFavorite || food.isFavorite)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $onlyFavorite) {
                    Text("Favorite Only")
                }
                ForEach(foodStore.stock) { food in
                    NavigationLink {
                        destination(food)
                    } label: {
                        FoodRowView(food: food)
                    }
                }
            }
            .navigationTitle("Foods")
            .toolbar {
                Button("Add") {
                    isAdding = true
                    newFood = Food.emptyFood
                }
            }
            .sheet(isPresented: $isAdding) {
                NavigationStack {
                    FoodEditView(food: $newFood, servingUnitType: .all)
                        .navigationTitle("Add New Food")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    isAdding = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    isAdding = false
                                    foodStore.stock.append(newFood)
                                }
                            }
                        }
                }
            }
            .onChange(of: scenePhase) { phase in
                if phase == .inactive { saveAction() }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        FoodListView(saveAction: {}, destination: { food in
            DiaryRecordEditView(diaryRecord: .constant(DiaryRecord.sampleData[0]), mealType: .constant(.breakfast), date: .constant(Date()))
            }
        )
            .environmentObject(FoodStore())
    }
}
