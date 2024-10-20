//
//  File.swift
//  GeneralReusableComponents
//
//  Created by Yasin Erdemli on 30/9/24.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

extension EnvironmentValues {
    @Entry var navigationController: UINavigationController?
}

struct InjectNavgigationController: ViewModifier {
    @State private var navigationController: UINavigationController?
    func body(content: Content) -> some View {
        content
            .environment(\.navigationController, navigationController)
            .introspect(.navigationStack, on: .iOS(.v17...)) { controller in
                self.navigationController = controller
            }
    }
}
