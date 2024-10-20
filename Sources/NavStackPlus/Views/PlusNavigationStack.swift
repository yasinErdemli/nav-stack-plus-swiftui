//
//  File.swift
//
//
//  Created by Yasin Erdemli on 18/8/24.
//

import SwiftUI

public struct PlusNavigationStack<Data, Root>: View where Root: View {
    @Binding var path: Data
    let root: Root
    public init(@ViewBuilder root: () -> Root) where Data == NavigationPath {
        self._path = .init(projectedValue: .constant(.init()))
        self.root = root()
    }
    public var body: some View {
        NavigationStack {
            CustomNavigationHeaderContainerView {
                root
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .injectNavControllerToEnvironment()
    }
}

extension PlusNavigationStack where Data == NavigationPath {
    public init(path: Binding<NavigationPath>, @ViewBuilder root: () -> Root) {
        self._path = path
        self.root = root()
    }
    @ViewBuilder public var body: some View {
        NavigationStack(path: $path) {
            CustomNavigationHeaderContainerView {
                root
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .injectNavControllerToEnvironment()
    }
}

extension PlusNavigationStack where Data: MutableCollection,
                                      Data: RandomAccessCollection,
                                      Data: RangeReplaceableCollection,
                                      Data.Element: Hashable {
    public init(path: Binding<Data>, @ViewBuilder root: () -> Root) {
        self._path = path
        self.root = root()
    }
    @ViewBuilder public var body: some View {
        NavigationStack(path: $path) {
            CustomNavigationHeaderContainerView {
                root
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .injectNavControllerToEnvironment()
    }
}

#Preview {
    PlusNavigationStack(path: .constant(.init())) {
        Color.red.ignoresSafeArea()
    }
}
