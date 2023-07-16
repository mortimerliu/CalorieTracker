//
//  ContentView.swift
//  CalorieTracker
//
//  Created by Hongru on 7/7/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var foodStore: FoodStore
    @EnvironmentObject var diaryStore: DiaryStore
    @State private var selection: Tab = .food

    enum Tab {
        case food
        case diary
    }
    
    var body: some View {
        TabView(selection: $selection) {
            // The tag(_:) modifier on each of the views matches one of the possible values that the selection property can take so the TabView can coordinate which view to display when the user makes a selection in the user interface.
            FoodListView() {
                Task {
                    do {
                        try await foodStore.save(stock: foodStore.stock)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            } destination: { food in
                FoodDetailView(food: food)
            }
                .tabItem {
                    Label("Food", systemImage: "list.bullet")
                }
                .tag(Tab.food)
            DiarySummaryView() {
                Task {
                    do {
                        try await diaryStore.save(stock: diaryStore.stock)
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
                .tabItem {
                    Label("Diary", systemImage: "list.bullet")
                }
                .tag(Tab.diary)
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        ContentView()
            .environmentObject(FoodStore.shared)
            .environmentObject(DiaryStore.shared)
    }
}
