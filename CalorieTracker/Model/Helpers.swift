//
//  Helpers.swift
//  CalorieTracker
//
//  Created by Hongru on 7/12/23.
//

import SwiftUI

struct FavoriteButton: View {
    // Because you use a binding, changes made inside this view propagate back to the data source.
    // A binding controls the storage for a value, so you can pass data around to different views that need to read or write it.
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            // The title string that you provide for the button’s label doesn’t appear in the UI when you use the iconOnly label style, but VoiceOver uses it to improve accessibility.
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundStyle(isSet ? .yellow : .gray)
        }
    }
}

#Preview {
    FavoriteButton(isSet: .constant(true))
}
