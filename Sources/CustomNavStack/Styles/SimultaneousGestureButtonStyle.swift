//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 26/8/24.
//

import SwiftUI

struct SimultaneousGestureButtonStyle: PrimitiveButtonStyle {
    let longPressAction: () -> Void
    @GestureState private var isPressing: Bool = false
    var maximumDistance: CGFloat = 30
    func makeBody(configuration: Configuration) -> some View {
        let drag = DragGesture(minimumDistance: 0)
            .updating($isPressing) { value, pressing, _ in
                pressing = true
                pressing = isUnderMaximum(value.location, value.startLocation)
            }
        configuration.label
            .scaleEffect(isPressing ? 0.95 : 1)
            .opacity(isPressing ? 0.9 : 1)
            .gesture(drag)
            .simultaneousGesture(
                TapGesture()
                    .onEnded(configuration.trigger)
            )
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.5, maximumDistance: maximumDistance)
                    .onEnded { _ in
                        longPressAction()
                    }
            )
    }

    func isUnderMaximum(_ first: CGPoint, _ second: CGPoint) -> Bool {
        let absoluteX = abs(first.x - second.x)
        let absoluteY = abs(first.y - second.y)
        let abSquared = pow(absoluteX, 2) + pow(absoluteY, 2)
        return !(sqrt(abSquared) > maximumDistance)
    }
}

extension PrimitiveButtonStyle where Self == SimultaneousGestureButtonStyle {
    static func simultaneous(longAction action: @escaping () -> Void) -> Self {
        .init(longPressAction: action)
    }
}
