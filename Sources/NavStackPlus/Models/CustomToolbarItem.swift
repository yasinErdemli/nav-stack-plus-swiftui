//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 19/8/24.
//

import SwiftUI

protocol CustomToolbarItemable: Identifiable, Hashable, Sendable {
    var id: UUID { get }
    var placement: CustomToolbarItemPlacement { get }
    var content: AnyView { get }
}

public struct CustomToolbarItem: CustomToolbarItemable {
    public let id: UUID = .init()
    let placement: CustomToolbarItemPlacement
    let content: AnyView

    public init<Content: View>(placement: CustomToolbarItemPlacement, @ViewBuilder content: () -> Content) {
        self.placement = placement
        self.content = AnyView(content())
    }

    public static func == (lhs: CustomToolbarItem, rhs: CustomToolbarItem) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension AnyView: @retroactive Sendable { }
