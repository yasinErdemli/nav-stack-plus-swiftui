//
//  SwiftUIView.swift
//  
//
//  Created by Yasin Erdemli on 23/8/24.
//

import SwiftUI

struct CustomNavigationHeaderContainerView<Content: View>: View {
    let content: Content
    @State private var labels: [CustomToolbarItem] = []
    @State private var backgroundOpacity: CGFloat = 0
    @State private var offset: CGFloat = .zero
    @State private var backButtonDisabled: Bool = false
    @State private var scrollDisabled: Bool = false
    @State private var background: EquatableViewContainer = .init {
        EmptyView()
    }
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .top, spacing: 0) {
                CustomNavigationHeader(
                    labels: labels,
                    background: background,
                    backgroundOpacity: backgroundOpacity,
                    backButtonDisabled: backButtonDisabled,
                    offset: offset)
            }
            .onPreferenceChange(ToolbarPreferenceKey.self) { value in
                self.labels = value
            }
            .onPreferenceChange(ToolbarBackgroundPreferenceKey.self) { value in
                self.background = value
            }
            .onPreferenceChange(ToolbarBackgroundOpacityPreferenceKey.self) { value in
                self.backgroundOpacity = value
            }
            .onPreferenceChange(GeometryScrollOpacityPreferenceKey.self) { value in
                self.backgroundOpacity = value
            }
            .onPreferenceChange(GeometryScrollOffsetPreferenceKey.self) { value in
                if !scrollDisabled {
                    self.offset = value
                } else {
                    self.offset = 0
                }
            }
            .onPreferenceChange(ToolbarBackButtonDisabledPreferenceKey.self) { value in
                self.backButtonDisabled = value
            }
            .onPreferenceChange(ToolbarScrollDisabledPreferenceKey.self) { value in
                self.scrollDisabled = value
            }
    }
}

#Preview {
    CustomNavigationHeaderContainerView {
        GeometryScrollView {
            VStack {
                ForEach(1..<30) { _ in
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 200)
                }
            }
        }
        .customToolbar {
            CustomToolbarItem(placement: .trailing) {
                Button("hello", systemImage: "xmark", action: {})
                    .font(.title.bold())
                    .labelStyle(.iconOnly)
            }
        }
    }
}
