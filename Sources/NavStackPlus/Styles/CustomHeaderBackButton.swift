//
//  File.swift
//
//
//  Created by Yasin Erdemli on 27/8/24.
//

import SwiftUI

struct CustomHeaderBackButton: View {
    @Binding var headerHeight: CGFloat
    @Environment(\.dismiss) var dismiss
    let previousControllers: [UIViewController]
    var body: some View {
        Menu {
            ForEach(previousControllers, id: \.description) { controller in
                Button(controller.navigationItem.title ?? "Untitled") {
                    popTo(controller: controller)
                }
            }
        } label: {
            Label(
                title: { Text("Back") },
                icon: { Image(systemName: "arrow.left.square").resizable() }
            )
        } primaryAction: {
            dismiss()
        }
        .labelStyle(.iconOnlyPlus(width: 23))
        .foregroundStyle(.primary)
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

extension CustomHeaderBackButton {
    private func popTo(controller: UIViewController) {
        controller.navigationController?.popToViewController(controller, animated: true)
    }
}
