//
//  FoodStore.swift
//  CalorieTracker
//
//  Created by Hongru on 7/9/23.
//

import Foundation
import SwiftUI
import Observation

// ObservableObject is a class-constrained protocol for connecting external model data to SwiftUI views.
// An ObservableObject includes an objectWillChange publisher that emits when one of its @Published properties is about to change. Any view observing an instance of ObservableObject will render again when the @Published properties value changes.
// The class must be marked as @MainActor before it is safe to update the published scrums property from the asynchronous load() method.

@MainActor
// @Observable
final class FoodStore: ObservableObject {
    static var shared: FoodStore {
        let fs = FoodStore()
        fs.stock = Food.sampleData
        return fs
    }
    static var fileName: String = "food-example.json"
    @Published var stock: Array<Food> = []
    
    func updateFood(_ newFood: Food) {
        guard let index = stock.firstIndex(where: { food in food.id == newFood.id}) else {
            return
        }
        stock[index] = newFood
    }
    
    private static func fileURL() throws -> URL {
        // use the shared instance of the FileManager class to get the location of the Documents directory for the current user
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appending(path: Self.fileName, directoryHint: .notDirectory)
    }
    
    func load() async throws {
        // The parameters tell the compiler that your closure returns [DailyScrum] and can throw an Error.
        let task = Task<[Food], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return Food.sampleData
            }
            let loadedFoods = try JSONDecoder().decode([Food].self, from: data)
            return loadedFoods
        }
        let foods = try await task.value
        self.stock = foods
    }
    
    func save(stock: [Food]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(stock)
            let outFile = try Self.fileURL()
            try data.write(to: outFile)
        }
        _ = try await task.value
    }
}
