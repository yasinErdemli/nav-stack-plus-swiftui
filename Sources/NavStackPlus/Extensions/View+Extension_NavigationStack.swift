//
//  File.swift
//
//
//  Created by Yasin Erdemli on 21/8/24.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect
import ScrollPlus

extension View {
    /// Associates a destination view with a presented data type for use within
    /// a navigation stack.
    ///
    /// Add this view modifier to a view inside a ``NavigationStackPlus`` to
    /// describe the view that the stack displays when presenting
    /// a particular kind of data. Use a ``NavigationLinkPlus`` to present
    /// the data. For example, you can present a `ColorDetail` view for
    /// each presentation of a ``Color`` instance:
    ///
    ///    NavigationStackPlus {
    ///        Rectangle()
    ///            .fill(.blue)
    ///            .ignoresSafeArea()
    ///            .toolbarPlus {
    ///                ToolbarItemPlus(placement: .leading) {
    ///                    Button("Profile", systemImage: "person.circle.fill", action: { })
    ///                        .font(.title)
    ///                }
    ///                ToolbarItemPlus(placement: .principal) {
    ///                    Text("Custom Nav Stack")
    ///                }
    ///                ToolbarItemPlus(placement: .trailing) {
    ///                    Button("More Options", systemImage: "ellipsis.circle.fill", action: {})
    ///                        .foregroundStyle(.purple)
    ///                }
    ///            }
    ///            .toolbarBackgroundPlus(opacity: 0.4)
    ///    }
    ///
    /// You can add more than one navigation destination modifier to the stack
    /// if it needs to present more than one kind of data.
    ///
    ///
    /// Do not put a navigation destination modifier inside a "lazy" container,
    /// like ``List`` or ``LazyVStack``. These containers create child views
    /// only when needed to render on screen. Add the navigation destination
    /// modifier outside these containers so that the navigation stack can
    /// always see the destination.
    ///
    /// - Parameters:
    ///   - data: The type of data that this destination matches.
    ///   - destination: A view builder that defines a view to display
    ///     when the stack's navigation state contains a value of
    ///     type `data`. The closure takes one argument, which is the value
    ///     of the data to present.
    public func navigationDestinationPlus<D, C>(
        for data: D.Type,
        @ViewBuilder destination: @escaping (D) -> C) -> some View where D: Hashable, C: View {
            self
                .navigationDestination(for: data) { item in
                    CustomNavigationHeaderContainerView {
                        destination(item)
                    }
                    .toolbar(.hidden, for: .navigationBar)
                }
        }

    /// Associates a destination view with a binding that can be used to push
    /// the view onto a ``NavigationStackPlus``.
    ///
    /// In general, favor binding a path to a navigation stack for programmatic
    /// navigation. Add this view modifier to a view inside a``NavigationStackPlus``
    /// to programmatically push a single view onto the stack. This is useful
    /// for building components that can push an associated view. For example,
    /// you can present a `ColorDetail` view for a particular color:
    ///
    ///    @State private var showDetails = false
    ///    var favoriteColor: Color
    ///
    ///    NavigationStackPlus {
    ///        VStack {
    ///            Circle()
    ///                .fill(favoriteColor)
    ///            Button("Show details") {
    ///                showDetails = true
    ///            }
    ///        }
    ///        .navigationDestinationPlus(isPresented: $showDetails) {
    ///            ColorDetail(color: favoriteColor)
    ///        }
    ///        .navigationTitle("My Favorite Color")
    ///    }
    ///
    /// Do not put a navigation destination modifier inside a "lazy" container,
    /// like ``List`` or ``LazyVStack``. These containers create child views
    /// only when needed to render on screen. Add the navigation destination
    /// modifier outside these containers so that the navigation stack can
    /// always see the destination.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that indicates whether
    ///     `destination` is currently presented.
    ///   - destination: A view to present.
    public func navigationDestinationPlus<V>(
        isPresented: Binding<Bool>,
        @ViewBuilder destination: () -> V) -> some View where V : View {
            self
                .navigationDestination(isPresented: isPresented) {
                    CustomNavigationHeaderContainerView(content: destination)
                        .toolbar(.hidden, for: .navigationBar)
                }

        }

    /// Associates a destination view with a bound value for use within a
    /// navigation stack or navigation split view
    ///
    /// Add this view modifier to a view inside a ``NavigationStackPlus``
    /// to describe the view that the stack displays
    /// when presenting a particular kind of data. Programmatically update
    /// the binding to display or remove the view. For example, you can replace
    /// the view showing in the detail column of a navigation split view:
    ///
    ///     @State private var colorShown: Color?
    ///
    ///     NavigationStackPlus {
    ///         GeometryScrollView {
    ///             Button("Mint") { colorShown = .mint }
    ///             Button("Pink") { colorShown = .pink }
    ///             Button("Teal") { colorShown = .teal }
    ///         }
    ///         .navigationDestinationPlus(item: $colorShown) { color in
    ///             ColorDetail(color: color)
    ///         }
    ///     }
    ///
    /// When the person using the app taps on the Mint button, the mint color
    /// shows in the detail and `colorShown` gets the value `Color.mint`. You
    /// can reset the navigation stack  to show the message "Select a color"
    /// by setting `colorShown` back to `nil`.
    ///
    /// You can add more than one navigation destination modifier to the stack
    /// if it needs to present more than one kind of data.
    ///
    /// Do not put a navigation destination modifier inside a "lazy" container,
    /// like ``List`` or ``LazyVStack``. These containers create child views
    /// only when needed to render on screen. Add the navigation destination
    /// modifier outside these containers so that the navigation split view can
    /// always see the destination.
    ///
    /// - Parameters:
    ///   - item: A binding to the data presented, or `nil` if nothing is
    ///     currently presented.
    ///   - destination: A view builder that defines a view to display
    ///     when `item` is not `nil`.
    public func navigationDestinationPlus<D, C>(
        item: Binding<D?>,
        @ViewBuilder destination: @escaping (D) -> C) -> some View where D : Hashable, C : View {
            self
                .navigationDestination(item: item) { item in
                    CustomNavigationHeaderContainerView {
                        destination(item)
                    }
                }
                .toolbar(.hidden, for: .bottomBar)
        }
}

extension View {
    @ViewBuilder
    public func toolbarPlus(@ToolbarItemPlusBuilder content: () -> [ToolbarItemPlus]) -> some View {
        self
            .preference(key: ToolbarPreferenceKey.self, value: content())
    }

    @ViewBuilder
    public func toolbarBackgroundPlus<Content: View>(@ViewBuilder _ background: () -> Content) -> some View {
        let value = EquatableViewContainer(content: background)
        self
            .preference(key: ToolbarBackgroundPreferenceKey.self, value: value)
    }

    @ViewBuilder
    public func toolbarBackgroundPlus(opacity: CGFloat) -> some View {
        self
            .transformPreference(GeometryScrollOpacityPreferenceKey.self) { value in
                value = opacity
            }
    }

    public func toolbarBackgroundPlus(maxOpacity: CGFloat) -> some View {
        self
            .transformPreference(GeometryScrollOpacityPreferenceKey.self) { value in
                value = min(maxOpacity, value)
            }
    }

    @ViewBuilder
    public func navigationBarBackButtonHiddenPlus(_ isHidden: Bool) -> some View {
        self
            .preference(key: ToolbarBackButtonDisabledPreferenceKey.self, value: isHidden)
    }

    @ViewBuilder
    public func navigationBarScrollDisabledPlus(_ isDisabled: Bool) -> some View {
        self
            .preference(key: ToolbarScrollDisabledPreferenceKey.self, value: isDisabled)
    }
}

extension View {
    func injectNavControllerToEnvironment() -> some View {
        self
            .modifier(InjectNavgigationController())
    }
}

extension View {
    public func navigationStackBackgroundColor(_ color: Color) -> some View {
        self
            .introspect(.navigationStack, on: .iOS(.v17...)) { stack in
                stack.viewControllers.forEach { $0.view.backgroundColor = UIColor(color) }
            }
    }
}
