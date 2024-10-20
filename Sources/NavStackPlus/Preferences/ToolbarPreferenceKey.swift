//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 25/8/24.
//

import SwiftUI

struct ToolbarPreferenceKey: PreferenceKey {
    static let defaultValue: [CustomToolbarItem] = []
    static func reduce(value: inout [CustomToolbarItem], nextValue: () -> [CustomToolbarItem]) {
        value += nextValue()
    }
}
