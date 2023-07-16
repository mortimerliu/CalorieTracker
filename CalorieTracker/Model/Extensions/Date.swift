//
//  Date.swift
//  CalorieTracker
//
//  Created by Hongru on 7/15/23.
//

import Foundation

extension Date {
    var dateString: String {
        self.formatted(.dateTime.day().month().year())
    }
}
