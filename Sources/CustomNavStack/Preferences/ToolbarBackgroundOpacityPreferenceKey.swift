//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 27/8/24.
//

import SwiftUI

struct ToolbarBackgroundOpacityPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { }
}
