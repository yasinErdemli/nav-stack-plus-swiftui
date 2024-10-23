//
//  File.swift
//  GeneralReusableComponents
//
//  Created by Yasin Erdemli on 23/9/24.
//

import SwiftUI

struct ToolbarScrollDisabledPreferenceKey: PreferenceKey {
    static let defaultValue: Bool = true
    static func reduce(value: inout Bool, nextValue: () -> Bool) { }
}
