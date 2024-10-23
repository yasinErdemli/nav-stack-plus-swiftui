//
//  File.swift
//  nav-stack-plus-swiftui
//
//  Created by Yasin Erdemli on 23/10/24.
//

import SwiftUI

@MainActor protocol NavigationStackProtocol: View {
    associatedtype Data
    associatedtype Root: View
    var path: Data { get set }
    var root: Root { get }

    var pathBinding: Binding<Data> { get }



}

extension NavigationStackProtocol {

    @ViewBuilder public var body: some View {
        returnView
    }

    @ViewBuilder var returnView: some View {

        NavigationStack {
            CustomNavigationHeaderContainerView {
                root
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .injectNavControllerToEnvironment()

    }
}

extension NavigationStackProtocol where Data == NavigationPath {
    @ViewBuilder var returnView: some View {
        NavigationStack(path: pathBinding) {
            CustomNavigationHeaderContainerView {
                root
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .injectNavControllerToEnvironment()

    }
}

extension NavigationStackProtocol where Data: MutableCollection, Data: RandomAccessCollection, Data: RangeReplaceableCollection, Data.Element: Hashable {
    @ViewBuilder var returnView: some View {
        NavigationStack(path: pathBinding) {
            CustomNavigationHeaderContainerView {
                root
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .injectNavControllerToEnvironment()
    }
}
