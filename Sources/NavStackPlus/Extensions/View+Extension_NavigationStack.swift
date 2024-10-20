//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 21/8/24.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect
import ScrollPlus

extension View {
    public func navigationDestinationPlus<D, C>(
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
    public func toolbarPlus(@ToolbarItemPlusBuilder content: () -> [ToolbarItemPlus]) -> some View {
        self
            .preference(key: ToolbarPreferenceKey.self, value: content())
    }

   @ViewBuilder
    public func toolbarBackgroundPlus<Content: View>(@ViewBuilder _ background: () -> Content) -> some View {
        let value = EquatableViewContainer(content: background)
        self
            .preference(key: ToolbarBackgroundPreferenceKey.self, value: value)
    }

    @ViewBuilder
    public func toolbarBackgroundPlus(opacity: CGFloat) -> some View {
        self
            .transformPreference(GeometryScrollOpacityPreferenceKey.self) { value in
                value = opacity
            }
    }

    public func toolbarBackgroundPlus(maxOpacity: CGFloat) -> some View {
        self
            .transformPreference(GeometryScrollOpacityPreferenceKey.self) { value in
                value = min(maxOpacity, value)
            }
    }

    @ViewBuilder
    public func navigationBarBackButtonHiddenPlus(_ isHidden: Bool) -> some View {
        self
            .preference(key: ToolbarBackButtonDisabledPreferenceKey.self, value: isHidden)
    }

    @ViewBuilder
    public func navigationBarScrollDisabledPlus(_ isDisabled: Bool) -> some View {
        self
            .preference(key: ToolbarScrollDisabledPreferenceKey.self, value: isDisabled)
    }
}

extension View {
    func injectNavControllerToEnvironment() -> some View {
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
