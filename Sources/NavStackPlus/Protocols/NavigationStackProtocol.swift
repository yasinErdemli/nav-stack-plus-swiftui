//
//  File.swift
//  nav-stack-plus-swiftui
//
//  Created by Yasin Erdemli on 23/10/24.
//

import SwiftUI

// Protocol needed for NavigationStackPlus since Swift doesn't support
// conformance to the same protocol even with different constraints.
// This protocol implements View, and using body just once but this body,
// gets it's view from the protocol's own returnView.
@MainActor public protocol NavigationStackProtocol {

    associatedtype Data
    associatedtype Root: View

    var path: Data { get set }
    var pathBinding: Binding<Data> { get }
    var root: Root { get }
}

extension NavigationStackProtocol {
    @ViewBuilder public var returnView: some View {
        NavigationStack {
            CustomNavigationHeaderContainerView {
                root
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .injectNavControllerToEnvironment()
    }
}

extension NavigationStackProtocol
where Data == NavigationPath {
    @ViewBuilder public var returnView: some View {
        NavigationStack(path: pathBinding) {
            CustomNavigationHeaderContainerView {
                root
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .injectNavControllerToEnvironment()
    }
}

extension NavigationStackProtocol
where Data: MutableCollection,
      Data: RandomAccessCollection,
      Data: RangeReplaceableCollection,
      Data.Element: Hashable
{
    @ViewBuilder public var returnView: some View {
        NavigationStack(path: pathBinding) {
            CustomNavigationHeaderContainerView {
                root
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .injectNavControllerToEnvironment()
    }
}
