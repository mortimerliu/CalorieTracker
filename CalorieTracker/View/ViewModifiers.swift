//
//  ViewModifiers.swift
//  CalorieTracker
//
//  Created by Hongru on 7/13/23.
//

import Foundation
import SwiftUI

extension Color {
    static let darkPink = Color(red: 208 / 255, green: 45 / 255, blue: 208 / 255)
}

struct UnderlineViewModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(color)
            .padding(10)
    }
}
