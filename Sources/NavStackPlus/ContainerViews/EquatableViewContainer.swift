//
//  File.swift
//
//
//  Created by Yasin Erdemli on 26/8/24.
//

import SwiftUI

struct EquatableViewContainer: Equatable, Sendable {
    private let id: UUID
    private let containedView: AnyView

    init() {
        self.id = .init()
        self.containedView = .init(EmptyView())
    }

    static func == (lhs: EquatableViewContainer, rhs: EquatableViewContainer) -> Bool {
        lhs.id == rhs.id
    }
}

extension EquatableViewContainer: View {
    init<Content: View>(@ViewBuilder content: () -> Content) {
        self.id = .init()
        self.containedView = .init(content())
    }

    var body: some View {
        containedView
    }
}

extension AnyView: @retroactive Sendable {}
