//
//  DatePicker.swift
//  CalorieTracker
//
//  Created by Hongru on 7/12/23.
//

import SwiftUI

struct DatePickerView<S: DatePickerStyle>: View {
    @Binding var date: Date
    var style: S
    var label: String = ""
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: date)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: date)!
        return min...max
    }
    
    var body: some View {
        VStack {
            DatePicker(selection: $date, in: dateRange, displayedComponents: .date) {
                Text(label)
            }
            .datePickerStyle(style)
            .navigationTitle("Change Date")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DatePickerView(date: .constant(Date()), style: .graphical)
}
