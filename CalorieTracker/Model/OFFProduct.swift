//
//  OFFItem.swift
//  CalorieTracker
//
//  Created by Hongru on 7/8/23.
//

import Foundation
import SwiftUI

struct OFFProduct: Hashable {
    typealias Units = Measurement<Dimension>
    
    var id: Int
    var name: String
    var nutritions: [NutritionItem]
    var baseUnit: Units
    
    var imageURL: String?
    var description: String?
    var categories: [String]
}

struct RawOFFProduct: Codable {
    let code: String
    let product: Product
    
    struct Product: Codable {
        let id: String
        let productName: String
        let categories: String
        let imageURL: String?
        let nutriments: Nutriments
        
        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case productName = "product_name"
            case categories
            case nutriments
            case imageURL = "image_url"
        }
    }
    
    struct Nutriments: Codable {
        let energy: Double
        let ennergyUnit: String
        let fat: Double
        let fatUnit: String
        let proteins: Double
        let proteinsUnit: String
        let carbohydrates: Double
        let carbohydratesUnit: String
        let sugars: Double?
        let sugarsUnit: String?
        let sodium: Double?
        let sodiumUnit: String?
        
        enum CodingKeys: String, CodingKey {
            case energy = "energy-kcal"
            case ennergyUnit = "energy-kcal_unit"
            case fat
            case fatUnit = "fat_unit"
            case proteins
            case proteinsUnit = "proteins_unit"
            case carbohydrates
            case carbohydratesUnit = "carbohydrates_unit"
            case sugars
            case sugarsUnit = "sugars_unit"
            case sodium
            case sodiumUnit = "sodium_unit"
        }
    }
}

extension OFFProduct: Codable {
    
    init(from decoder: Decoder) throws {
        let rawProduct = try RawOFFProduct(from: decoder)
        guard let rawID = Int(rawProduct.product.id) else {
            fatalError("No ID")
        }
        id = rawID
        name = rawProduct.product.productName
        imageURL = rawProduct.product.imageURL
        let nutriments = rawProduct.product.nutriments
        nutritions = [
//            NutritionItem(type: .calorie, measurement: Measurement(value: nutriments.energy, unit: getUnitType(nutriments.ennergyUnit))),
//            NutritionItem(type: .protein, measurement: Measurement(value: nutriments.proteins, unit: getUnitType(nutriments.proteinsUnit))),
//            NutritionItem(type: .fat, measurement: Measurement(value: nutriments.fat, unit: getUnitType(nutriments.fatUnit))),
//            NutritionItem(type: .carbohydrate, measurement: Measurement(value: nutriments.carbohydrates, unit: getUnitType(nutriments.carbohydratesUnit))),
        ]
//        if let rawSugar = nutriments.sugars, let rawSugarUnit = nutriments.sugarsUnit {
//            // nutritions.append(NutritionItem(type: .sugar, measurement: Measurement(value: rawSugar, unit: getUnitType(rawSugarUnit))))
//            
//        }
//        if let rawSodium = nutriments.sugars, let rawSodiumUnit = nutriments.sodiumUnit {
//            // nutritions.append(NutritionItem(type: .sodium, measurement: Measurement(value: rawSodium, unit: getUnitType(rawSodiumUnit))))
//
//        }
            
        baseUnit = Measurement(value: 100, unit: UnitMass.grams) // TODO
        categories = rawProduct.product.categories.split(separator: ",").map { String($0) }
    }
}

func getUnitType(_ unitString: String) -> Dimension {
    let unit = switch unitString {
    case "g":
        UnitMass.grams
    case "mg":
        UnitMass.milligrams
    default:
        UnitMass.grams
    }
    return unit
}
