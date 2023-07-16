//
//  DiaryRecordRowView.swift
//  CalorieTracker
//
//  Created by Hongru on 7/13/23.
//

import SwiftUI

struct DiaryRecordRowView: View {
    var diaryRecord: DiaryRecord
    
    var body: some View {
        HStack {
            (diaryRecord.food.image ?? Image("default-placeholder-300x300_3"))
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(5)
            VStack(alignment: .leading) {
                HStack {
                    Text(diaryRecord.food.name)
                        .bold()
                    Text(diaryRecord.serving.asString)
                }
                Text(diaryRecord.nutrition[.calorie].asString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                    
            }
            Spacer()
        }
    }
}

#Preview {
    DiaryRecordRowView(diaryRecord: DiaryRecord.sampleData[0])
}
