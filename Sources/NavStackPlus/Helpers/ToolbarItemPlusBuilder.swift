//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 26/8/24.
//

import SwiftUI

@resultBuilder
public struct ToolbarItemPlusBuilder {
    public static func buildBlock(_ components: ToolbarItemPlus...) -> [ToolbarItemPlus] {
        return components
    }
}
