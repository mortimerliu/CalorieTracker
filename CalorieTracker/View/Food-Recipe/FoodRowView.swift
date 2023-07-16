//
//  FoodRowView.swift
//  CalorieTracker
//
//  Created by Hongru on 7/11/23.
//

import SwiftUI

struct FoodRowView: View {
    var food: Food
    
    var body: some View {
        HStack {
            (food.image ?? Image("default-placeholder-300x300_3"))
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(5)
            VStack(alignment: .leading) {
                Text(food.name)
                    .bold()
                Text(food.nutrition[.calorie].asString)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if food.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MainActor.assumeIsolated {
        FoodRowView(food: Food.sampleData[0])
    }
}
