//
//  CalorieTrackerApp.swift
//  CalorieTracker
//
//  Created by Hongru on 7/7/23.
//

import SwiftUI

@main
struct CalorieTrackerApp: App {
    @StateObject private var foodStore = FoodStore()
    @StateObject private var diaryStore = DiaryStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(foodStore)
            .environmentObject(diaryStore)
            .task {
                do {
                    try await foodStore.load()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
            .task {
                do {
                    try await diaryStore.load()
                } catch {
                    fatalError(error.localizedDescription)
                }
            }
        }
    }
}
