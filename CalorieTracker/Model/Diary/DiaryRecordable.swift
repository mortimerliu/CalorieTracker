//
//  DiaryRecordable.swift
//  CalorieTracker
//
//  Created by Hongru on 7/9/23.
//

import Foundation
import SwiftUI

protocol DiaryRecordable: Hashable, Codable {
    var name: String { get }
    var nutrition: Nutrition { get }
    var serving: Serving { get }
    var image: Image? { get }
}
