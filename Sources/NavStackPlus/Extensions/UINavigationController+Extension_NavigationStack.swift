//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 25/8/24.
//

import SwiftUI

// This is needed to regain slide to back functionality when navigation button is hidden.
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
