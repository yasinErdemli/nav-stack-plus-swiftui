//
//  SwiftUIView.swift
//
//
//  Created by Yasin Erdemli on 23/8/24.
//

import ScrollPlus
import SwiftUI

struct CustomNavigationHeaderContainerView<Content: View>: View {
    let content: Content
    @State private var labels: [ToolbarItemPlus] = []
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
            .onPreferenceChange(GeometryScrollOpacityPreferenceKey.self) {
                value in
                self.backgroundOpacity = value
            }
            .onPreferenceChange(GeometryScrollOffsetPreferenceKey.self) { value in
                if !scrollDisabled {
                    self.offset = value
                } else {
                    self.offset = 0
                }
            }
            .onPreferenceChange(ToolbarBackButtonDisabledPreferenceKey.self) {
                value in
                self.backButtonDisabled = value
            }
            .onPreferenceChange(ToolbarScrollDisabledPreferenceKey.self) {
                value in
                self.scrollDisabled = value
            }
    }
}

//#Preview {
//    CustomNavigationHeaderContainerView {
//        ZStack {
//            Rectangle()
//                .fill(.blue)
//                .ignoresSafeArea()
//            GeometryScrollView {
//                VStack {
//                    ForEach(1..<30) { _ in
//                        RoundedRectangle(cornerRadius: 20)
//                            .frame(height: 200)
//                    }
//                }
//            }
//        }
//        .toolbarPlus {
//            ToolbarItemPlus(placement: .leading) {
//                Button("Profile",
//                       systemImage: "person.circle.fill",
//                       action: {}
//                )
//                    .font(.title)
//            }
//            ToolbarItemPlus(placement: .principal) {
//                Text("Custom Nav Stack")
//            }
//            ToolbarItemPlus(placement: .trailing) {
//                Button(
//                    "More Options",
//                    systemImage: "ellipsis.circle.fill",
//                    action: {}
//                )
//                .foregroundStyle(.purple)
//            }
//        }
//        .toolbarBackgroundPlus(maxOpacity: 0.5)
//        .navigationBarScrollDisabledPlus(false)
//    }
//}
