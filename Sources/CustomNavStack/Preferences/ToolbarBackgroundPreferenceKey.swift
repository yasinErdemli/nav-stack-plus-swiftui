//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 25/8/24.
//

import SwiftUI

struct ToolbarBackgroundPreferenceKey: PreferenceKey {
    static let defaultValue = EquatableViewContainer {
        Rectangle()
            .fill(.thinMaterial)
            .ignoresSafeArea(.container, edges: .top)
    }
    static func reduce(value: inout EquatableViewContainer, nextValue: () -> EquatableViewContainer) {
        let nextValue = nextValue()
        if nextValue != defaultValue {
            value = nextValue
        }
    }
}
