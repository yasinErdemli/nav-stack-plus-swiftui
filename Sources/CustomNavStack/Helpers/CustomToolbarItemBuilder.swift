//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 26/8/24.
//

import SwiftUI

@resultBuilder
public struct CustomToolbarItemBuilder {
    public static func buildBlock(_ components: CustomToolbarItem...) -> [CustomToolbarItem] {
        return components
    }
}
