//
//  File.swift
//  
//
//  Created by Yasin Erdemli on 26/8/24.
//

import SwiftUI

public struct CustomNavigationHeaderIconOnlyLabelStyle: LabelStyle {
    let size: CGSize
    public func makeBody(configuration: Configuration) -> some View {
        configuration.icon
            .scaledToFill()
            .frame(width: size.width, height: size.height)
    }
}

extension LabelStyle where Self == CustomNavigationHeaderIconOnlyLabelStyle {
    public static func iconOnlyPlus(size: CGSize) -> CustomNavigationHeaderIconOnlyLabelStyle {
        CustomNavigationHeaderIconOnlyLabelStyle(size: size)
    }
    public static func iconOnlyPlus(
        width: CGFloat? = nil,
        height: CGFloat? = nil) -> CustomNavigationHeaderIconOnlyLabelStyle {
            if let width, height == nil {
                return CustomNavigationHeaderIconOnlyLabelStyle(size: .init(width: width, height: width))
            } else if let height, width == nil {
                return CustomNavigationHeaderIconOnlyLabelStyle(size: .init(width: height, height: height))
            } else if let height, let width {
                return CustomNavigationHeaderIconOnlyLabelStyle(size: .init(width: width, height: height))
            }
            return iconOnlyPlus()
    }
    public static var iconOnlyPlus: CustomNavigationHeaderIconOnlyLabelStyle {
        CustomNavigationHeaderIconOnlyLabelStyle(size: .init(width: 44, height: 44))
    }
}
