//
//  ToolbarBackButtonDisabledPreferenceKey.swift
//  GeneralReusableComponents
//
//  Created by Yasin Erdemli on 23/9/24.
//

import SwiftUI

struct ToolbarBackButtonDisabledPreferenceKey: PreferenceKey {
    static let defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) { }
}
