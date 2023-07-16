//
//  DiaryStore.swift
//  CalorieTracker
//
//  Created by Hongru on 7/12/23.
//

import Foundation

@MainActor
final class DiaryStore: ObservableObject {
    static var shared: DiaryStore {
        let ds = DiaryStore()
        ds.stock = DiaryRecord.sampleDiaryData
        return ds
    }
    
    static var fileName: String = "diary-example.json"
    @Published var stock: [String: [MealType: [DiaryRecord]]] = [:]
    
    func update(date: String, mealType: MealType, diaryRecord: DiaryRecord) {
        remove(diaryRecord: diaryRecord)
        insert(date: date, mealType: mealType, diaryRecord: diaryRecord)
    }
    
    func insert(date: String, mealType: MealType, diaryRecord: DiaryRecord) {
        var perDay = stock[date, default: [:]]
        var perMeal = perDay[mealType, default: [DiaryRecord]()]
        perMeal.append(diaryRecord)
        perDay[mealType] = perMeal
        stock[date] = perDay
    }
    
    func remove(diaryRecord: DiaryRecord) {
        for (date, perDay) in stock {
            for (mealType, perMeal) in perDay {
                if let index = perMeal.firstIndex(where: { $0.id == diaryRecord.id }) {
                    stock[date]?[mealType]?.remove(at: index)
                    return
                }
            }
        }
    }
    
    private static func fileURL() throws -> URL {
        // use the shared instance of the FileManager class to get the location of the Documents directory for the current user
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appending(path: Self.fileName, directoryHint: .notDirectory)
    }
    
    func load() async throws {
        // The parameters tell the compiler that your closure returns [DailyScrum] and can throw an Error.
        let task = Task<[String: [MealType: [DiaryRecord]]], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return [:] //Diary.sampleData
            }
            let loadedFoods = try JSONDecoder().decode([String: [MealType: [DiaryRecord]]].self, from: data)
            return loadedFoods
        }
        let foods = try await task.value
        self.stock = foods
    }
    
    func save(stock: [String: [MealType: [DiaryRecord]]]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(stock)
            let outFile = try Self.fileURL()
            try data.write(to: outFile)
        }
        _ = try await task.value
    }
}
