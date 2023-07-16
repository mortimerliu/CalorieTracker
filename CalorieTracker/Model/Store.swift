//
//  Store.swift
//  CalorieTracker
//
//  Created by Hongru on 7/12/23.
//

import Foundation
import SwiftUI

protocol DefaultInit {
    init()
}

// A store manages a collection of items
class Store<Stock: Collection & DefaultInit & Codable> {
//    associatedtype Container: Collection & Codable & DefaultInit
//
    static var fileName: String { "" }
    var stock: Stock = Stock() // { get set }

    static func fileURL() throws -> URL {
        // use the shared instance of the FileManager class to get the location of the Documents directory for the current user
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appending(path: Self.fileName, directoryHint: .notDirectory)
    }
    
    func load() async throws {
        // The parameters tell the compiler that your closure returns [DailyScrum] and can throw an Error.
        let task = Task<Stock, Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return Stock()
            }
            let loadedFoods = try JSONDecoder().decode(Stock.self, from: data)
            return loadedFoods
        }
        let stock = try await task.value
        self.stock = stock
    }
    
    func save(stock: Stock) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(stock)
            let outFile = try Self.fileURL()
            try data.write(to: outFile)
        }
        _ = try await task.value
    }
}

extension Array: DefaultInit {}
extension Dictionary: DefaultInit {}

//protocol ArrayStore: Store where Container == Array<Element> {
//    associatedtype Element = Container.Element
//}
//
//protocol DictionaryStore: Store where Container == Dictionary<Key, Value> {
//    associatedtype Key: Hashable
//    associatedtype Value
//    associatedtype Element = Container.Element
//}

class ArrayStore<Element: Codable>: Store<Array<Element>> {}
class DictionaryStore<Key: Hashable & Codable, Value: Codable>: Store<Dictionary<Key, Value>> {}
