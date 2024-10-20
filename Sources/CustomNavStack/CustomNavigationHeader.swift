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
    @State private var previousControllers: [UIViewController] = []
    var body: some View {
        HStack {
            Spacer()
                .overlay(alignment: .leading) {
                    HStack {
                        if !isFirstController && !backButtonDisabled {
                            CustomHeaderBackButton(
                                headerHeight: $headerHeight,
                                previousControllers: previousControllers)
                        }
                        ForEach(leadingLabels) { label in
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
                .overlay(alignment: .trailing) {
                    HStack {
                        ForEach(trailingLabels) { label in
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
        .labelStyle(.customIconOnly(size: .init(width: 44, height: 44)))
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
            Task {
                await MainActor.run {
                    self.previousControllers = getPreviousControllers()
                }
            }
        }
        .offset(y: -offset)
    }

}

extension CustomNavigationHeader {
    private func getCurrentNavigationViewController() -> UINavigationController? {
        let application = UIApplication.shared
        guard let tabBarController = application.findTabController() else {
            return application.findNavigationController()
        }
        let selectedViewController = tabBarController.selectedViewController
        return application.findNavigationController(viewController: selectedViewController)
    }

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
    return ExampleView()
    struct ExampleView: View {
        @State private var offset: CGFloat = 0

        var body: some View {
            CustomNavigationStack {
                Rectangle()
                    .fill(.blue)
                    .ignoresSafeArea()
                    .task {

                    }
                    .customToolbar {
                        CustomToolbarItem(placement: .leading) {
                            Button(action: {}, label: {
                                Label {
                                    Text("Hello")
                                } icon: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                }
                            })
                        }
                        CustomToolbarItem(placement: .principal) {
                            Label {
                                Text("Hello")
                            } icon: {
                                Image(uiImage: .actions)
                                    .resizable()
                            }
                        }

                        CustomToolbarItem(placement: .trailing) {
                            Label {
                                Text("World")
                            } icon: {
                                Image(uiImage: .actions)
                                    .resizable()
                            }
                        }

                        CustomToolbarItem(placement: .leading) {
                            Label {
                                Text("Hello")
                            } icon: {
                                Image(uiImage: .actions)
                                    .resizable()
                            }
                        }

                        CustomToolbarItem(placement: .trailing) {
                            Label(
                                title: { Text("Hi") },
                                icon: { Image(systemName: "person.fill").resizable() }
                            )
                        }
                    }
                    .customToolbarBackground(opacity: 1)
            }
            .preferredColorScheme(.dark)
        }
    }
}
