//
//  DiaryView.swift
//  CalorieTracker
//
//  Created by Hongru on 7/12/23.
//

import SwiftUI

struct DiarySummaryView: View {
    @EnvironmentObject var foodStore: FoodStore
    @EnvironmentObject var diaryStore: DiaryStore
    
    // state var for date picker
    @State private var date: Date = Date()
    @State private var draftDate: Date = Date()
    @State private var showDatePicker = false
    
    @State private var draftDiaryRecord: DiaryRecord = DiaryRecord.sampleData[0]
    @State private var draftMealType = MealType.breakfast
    @State private var isEditing = false
    @State private var isAdding = false
    
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: () -> Void

    private var diary: [MealType: [DiaryRecord]]? {
        diaryStore.stock[date.dateString]
    }
    
    private var totalNutrition: Nutrition {
        var nutrition = Nutrition()
        if let diary {
            for (_, records) in diary {
                for record in records {
                    nutrition += record.nutrition
                }
            }
        }
        return nutrition
    }
    
    var body: some View {
        NavigationStack {
            List {
//                Button {
//                    showDatePicker = true
//                    tempDate = date
//                } label: {
//                    Text(date.formatted(.dateTime.day().month().year()))
//                        .frame(maxWidth: .infinity)
//                }
//                .buttonStyle(BorderlessButtonStyle())
                
                Section("Daily Summary") {
                    NutritionRowView(item: totalNutrition[.calorie])
                    NutritionRowView(item: totalNutrition[.carbohydrate])
                    NutritionRowView(item: totalNutrition[.protein])
                    NutritionRowView(item: totalNutrition[.fat])
                }
                if let diary {
                    ForEach(MealType.allCases, id: \.self) { mealType in
                        Section(mealType.rawValue.capitalized) {
                            if let diaryRecords = diary[mealType] {
                                ForEach(diaryRecords) { record in
//                                    NavigationLink {
//                                        DiaryRecordEditView(diaryRecord: $draftDiaryRecord)
//                                    } label: {
//                                        DiaryRecordRowView(diaryRecord: record)
//                                    }
                                    Button {
                                        isEditing = true
                                        draftDiaryRecord = record
                                        draftMealType = mealType
                                        draftDate = date
                                    } label: {
                                        DiaryRecordRowView(diaryRecord: record)
                                    }
                                    .foregroundStyle(.primary)
                                }
                            }
                            Button {
                                isAdding = true
                                draftMealType = mealType
                                draftDate = date
                            } label: {
                                Label("Add more", systemImage: "plus.circle.fill")
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
                        showDatePicker = true
                        draftDate = date
                    } label: {
                        Text(date.formatted(.dateTime.day().month().year()))
                            .frame(maxWidth: .infinity)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAdding = true
                        draftMealType = .breakfast
                        draftDate = date
                    } label: {
                        Label { Text("Add") } icon: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showDatePicker) {
            NavigationStack {
                DatePickerView(date: $draftDate, style: .graphical)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button {
                                showDatePicker = false
                            } label: {
                                Label { Text("Cancel") } icon: {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                showDatePicker = false
                                date = draftDate
                            } label: {
                                Label { Text("Done") } icon: {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                }
            }
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $isAdding) {
            NavigationStack {
                List {
                    ForEach(foodStore.stock) { food in
                        NavigationLink(value: food) {
                            FoodRowView(food: food)
                        }
                    }
                }
                .navigationDestination(for: Food.self) { food in
                    DiaryRecordEditView(diaryRecord: $draftDiaryRecord, mealType: $draftMealType, date: $draftDate, food: food)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    isAdding = false
                                    diaryStore.insert(date: draftDate.dateString, mealType: draftMealType, diaryRecord: draftDiaryRecord)
                                    date = draftDate
                                }
                            }
                        }
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isAdding = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            isAdding = false
                            diaryStore.insert(date: draftDate.dateString, mealType: draftMealType, diaryRecord: draftDiaryRecord)
                            date = draftDate
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            NavigationStack {
                DiaryRecordEditView(diaryRecord: $draftDiaryRecord, mealType: $draftMealType, date: $draftDate)
                    .navigationTitle(draftDiaryRecord.food.name)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                isEditing = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                isEditing = false
                                diaryStore.update(date: draftDate.dateString, mealType: draftMealType, diaryRecord: draftDiaryRecord)
                                date = draftDate
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

#Preview {
    MainActor.assumeIsolated {
        DiarySummaryView(saveAction: {})
            .environmentObject(DiaryStore.shared)
            .environmentObject(FoodStore.shared)
    }
}



