//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 25/8/24.
//

import SwiftUI

struct ToolbarPreferenceKey: PreferenceKey {
    static let defaultValue: [ToolbarItemPlus] = []
    static func reduce(value: inout [ToolbarItemPlus], nextValue: () -> [ToolbarItemPlus]) {
        value += nextValue()
    }
}
