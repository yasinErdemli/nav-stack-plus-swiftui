//
//  SwiftUIView.swift
//
//
//  Created by Yasin Erdemli on 19/8/24.
//

import SwiftUI

struct CustomNavigationHeader: View {
    let labels: [CustomToolbarItem]
    let background: EquatableViewContainer
    let backgroundOpacity: CGFloat
    let backButtonDisabled: Bool
    let offset: CGFloat
    @State private var headerHeight: CGFloat = .zero
    @Environment(\.dismiss) var dismiss
    @Environment(\.navigationController) var navigationController
    @Environment(\.layoutDirection) var layoutDirection
    @State private var previousControllers: [UIViewController] = []
    var body: some View {
        HStack {
            Spacer()
                .overlay(alignment: layoutDirection == .leftToRight ? .leading : .trailing) {
                    HStack {
                        if !isFirstController && !backButtonDisabled {
                            CustomHeaderBackButton(
                                headerHeight: $headerHeight,
                                previousControllers: previousControllers)
                        }
                        ForEach(layoutDirection == .leftToRight ? leadingLabels : trailingLabels) { label in
                            label.content
                                .background {
                                    GeometryReader { geo in
                                        Color.clear
                                            .task {
                                                headerHeight = max(headerHeight, geo.size.height)
                                            }
                                    }
                                }
                        }
                    }
                }
            if let principalLabel {
                principalLabel.content
                    .background {
                        GeometryReader { geo in
                            Color.clear
                                .task {
                                    headerHeight = max(headerHeight, geo.size.height)
                                }
                        }
                    }
            }
            Spacer()
                .overlay(alignment: layoutDirection == .leftToRight ? .trailing : .leading) {
                    HStack {
                        ForEach(layoutDirection == .leftToRight ? trailingLabels : leadingLabels) { label in
                            label.content
                                .background {
                                    GeometryReader { geo in
                                        Color.clear
                                            .task {
                                                headerHeight = max(headerHeight, geo.size.height)
                                            }
                                    }
                                }
                        }
                    }
                }
        }
        .frame(height: headerHeight)
        .font(.title3)
        .labelStyle(.iconOnly)
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .background {
            background
                .padding(.horizontal, -16)
                .padding(.top, -80)
                .opacity(backgroundOpacity)
        }
        .opacity((labels.isEmpty && (isFirstController || backButtonDisabled)) ? 0 : 1)
        .frame(height: (labels.isEmpty && (isFirstController || backButtonDisabled)) ? 0 : nil)
        .onAppear {
            self.previousControllers = getPreviousControllers()
        }
        .offset(y: -offset)
    }

}

extension CustomNavigationHeader {
    private func getPreviousControllers() -> [UIViewController] {
        guard let viewControllers = navigationController?.viewControllers else {
            return []
        }
        return viewControllers.dropLast()
    }

    private var isFirstController: Bool {
        return previousControllers.isEmpty
    }
}

extension CustomNavigationHeader {
    private var trailingLabels: [CustomToolbarItem] {
        getValues(for: labels, selection: .trailing, max: 2)
    }
    private var principalLabel: CustomToolbarItem? {
        getValues(for: labels, selection: .principal, max: 1).last
    }
    private var leadingLabels: [CustomToolbarItem] {
        getValues(for: labels, selection: .leading, max: 2)
    }
    private func getValues(
        for items: [CustomToolbarItem],
        selection: CustomToolbarItemPlacement,
        max value: Int) -> [CustomToolbarItem] {
            let usableItems = items.filter { $0.placement == selection }
            let toBeDeletedCount = abs(min(0, value - usableItems.count))
            return usableItems.dropFirst(toBeDeletedCount).map { $0 }.reversed()
        }
}

#Preview {
    PlusNavigationStack {
        Rectangle()
            .fill(.blue)
            .ignoresSafeArea()
            .toolbarPlus {
                CustomToolbarItem(placement: .leading) {
                    Button("Profile", systemImage: "person.circle.fill", action: { })
                        .font(.title)
                }
                CustomToolbarItem(placement: .principal) {
                    Text("Custom Nav Stack")
                }
                CustomToolbarItem(placement: .trailing) {
                    Button("More Options", systemImage: "ellipsis.circle.fill", action: {})
                        .foregroundStyle(.purple)
                }
            }
            .toolbarBackgroundPlus(opacity: 0.4)
    }
}
