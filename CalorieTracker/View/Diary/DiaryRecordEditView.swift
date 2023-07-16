//
//  DiaryEditView.swift
//  CalorieTracker
//
//  Created by Hongru on 7/13/23.
//

import SwiftUI
import Combine

struct DiaryRecordEditView: View {
    @Binding var diaryRecord: DiaryRecord
    @Binding var mealType: MealType
    @Binding var date: Date
    
    init(diaryRecord: Binding<DiaryRecord>, mealType: Binding<MealType>, date: Binding<Date>, food: Food? = nil) {
        self._diaryRecord = diaryRecord
        self._mealType = mealType
        self._date = date
        if let food {
            self.diaryRecord = DiaryRecord(food: food, serving: food.serving)
        }
    }
    
    var body: some View {
        List {
            FoodRowView(food: diaryRecord.food)
//            NavigationLink {
//                DiaryFoodChooserView(food: $diaryRecord.food)
//            } label: {
//                FoodRowView(food: diaryRecord.food)
//            }
            HStack {
                Text("Serving Size")
                Spacer()
                TextField("Serving Size", value: $diaryRecord.serving.value, formatter: NumberFormatter())
                    //.frame(width: 50)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numberPad)
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                            if let textField = obj.object as? UITextField {
                                textField.selectAll(nil)
                            }
                        }
                //.modifier(UnderlineViewModifier(color: .primary))
            }
            Picker("Serving Unit", selection: $diaryRecord.serving.unit) {
                ForEach(diaryRecord.food.serving.unit.type.allUnits) { unit in
                    Text(unit.dimension.symbol).tag(unit)
                }
            }
            Picker("Meal", selection: $mealType) {
                ForEach(MealType.allCases) { type in
                    Text(type.rawValue.capitalized).tag(type)
                }
            }
            DatePickerView(date: $date, style: .compact, label: "Date")
        }
        .navigationTitle("Edit Diary Record")
    }
}

#Preview {
    MainActor.assumeIsolated {
        DiaryRecordEditView(
            diaryRecord: .constant(DiaryRecord.sampleData[0]),
            mealType: .constant(.breakfast),
            date: .constant(Date())
        )
            .environmentObject(FoodStore.shared)
    }
}
