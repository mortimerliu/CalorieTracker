//
//  Double.swift
//  CalorieTracker
//
//  Created by Hongru on 7/9/23.
//

import Foundation

extension Double {
    var twoDecimalRounded: Double {
        return (self * 100).rounded() / 100
    }

    var asTwoDecimalRoundedString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSDecimalNumber(value: self)) ?? ""
    }
}

