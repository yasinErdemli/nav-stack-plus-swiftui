//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 21/8/24.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

extension View {
    public func customNavigationDestination<D, C>(
        for data: D.Type,
        @ViewBuilder destination: @escaping (D) -> C) -> some View where D: Hashable, C: View {
        self
            .navigationDestination(for: data) { item in
                CustomNavigationHeaderContainerView {
                    destination(item)
                }
                .toolbar(.hidden, for: .navigationBar)
            }
    }
}

extension View {
    @ViewBuilder
    public func customToolbar(@CustomToolbarItemBuilder content: () -> [CustomToolbarItem]) -> some View {
        self
            .preference(key: ToolbarPreferenceKey.self, value: content())
    }

   @ViewBuilder
    public func customToolbarBackground<Content: View>(@ViewBuilder _ background: () -> Content) -> some View {
        let value = EquatableViewContainer(content: background)
        self
            .preference(key: ToolbarBackgroundPreferenceKey.self, value: value)
    }

    @ViewBuilder
    public func customToolbarBackground(opacity: CGFloat) -> some View {
        self
            .preference(key: ToolbarBackgroundOpacityPreferenceKey.self, value: opacity)
    }

    @ViewBuilder
    public func customToolbarBackButtonHidden(_ isHidden: Bool) -> some View {
        self
            .preference(key: ToolbarBackButtonDisabledPreferenceKey.self, value: isHidden)
    }

    @ViewBuilder
    public func customToolbarScrollDisabled(_ isDisabled: Bool) -> some View {
        self
            .preference(key: ToolbarScrollDisabledPreferenceKey.self, value: isDisabled)
    }
}

extension View {
    public func injectNavControllerToEnvironment() -> some View {
        self
            .modifier(InjectNavgigationController())
    }
}

extension View {
    public func navigationStackBackgroundColor(_ color: Color) -> some View {
        self
            .introspect(.navigationStack, on: .iOS(.v17...)) { stack in
                stack.viewControllers.forEach { $0.view.backgroundColor = UIColor(color) }
            }
    }
}
