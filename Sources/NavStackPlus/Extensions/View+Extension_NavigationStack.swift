//
//  File.swift
//
//
//  Created by Yasin Erdemli on 21/8/24.
//

import ScrollPlus
import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

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
        @ViewBuilder destination: @escaping (D) -> C
    ) -> some View where D: Hashable, C: View {
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
        @ViewBuilder destination: () -> V
    ) -> some View where V: View {
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
        @ViewBuilder destination: @escaping (D) -> C
    ) -> some View where D: Hashable, C: View {
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

    /// Populates the NavigationStackPlus bar with the specified items.
    ///
    /// Use this method to populate a navigation bar with a collection of views that
    /// you provide to a toolbar view builder.
    ///
    /// The toolbarPlus modifier expects a collection of toolbar items which you can
    /// provide  by supplying a collection of views with each view
    /// wrapped in a ``ToolbarItemPlus``. The example below uses a collection of
    /// ``ToolbarItemPlus`` views to create a navigation bar.:
    ///
    ///     struct StructToolbarItemView: View {
    ///         var body: some View {
    ///             Text("Toolbar Example)
    ///                 .toolbarPlus {
    ///                     ToolbarItemPlus(placement: .leading) {
    ///                         Button(
    ///                         "Profile", systemImage: "person.circle.fill",
    ///                         action: {}
    ///                         )
    ///                         .font(.title)
    ///                     }
    ///                     ToolbarItemPlus(placement: .principal) {
    ///                         Text("Custom Nav Stack")
    ///                     }
    ///                     ToolbarItemPlus(placement: .trailing) {
    ///                         Button(
    ///                         "More Options", systemImage: "ellipsis.circle.fill",
    ///                         action: {}
    ///                         )
    ///                         .foregroundStyle(.purple)
    ///                     }
    ///                 }
    ///             }
    ///     }
    ///
    /// - Parameter content: The items representing the content of the toolbar.
    @ViewBuilder
    public func toolbarPlus(
        @ToolbarItemPlusBuilder content: () -> [ToolbarItemPlus]
    ) -> some View {
        self
            .preference(key: ToolbarPreferenceKey.self, value: content())
    }
    
    /// Changes the default background of the navigationBar with the one you provide.
    ///
    ///     struct ToolbarBackgroundView: View {
    ///         var body: some View {
    ///             Text("Toolbar Background Example)
    ///                 .toolbarBackgroundPlus {
    ///                     Rectangle()
    ///                         .fill(.red)
    ///                 }
    ///         }
    ///     }
    ///
    /// - Parameter background: View that will be put on the background instead of the
    /// default material.
    @ViewBuilder
    public func toolbarBackgroundPlus<Content: View>(
        @ViewBuilder _ background: () -> Content
    ) -> some View {
        let value = EquatableViewContainer(content: background)
        self
            .preference(key: ToolbarBackgroundPreferenceKey.self, value: value)
    }

    
    /// Changes the opacity of the background with the default one. This make it so that even if
    /// ``GeometryScrollView`` provides an opacity, it will be overriden by this.
    ///
    ///     struct ToolbarBackgroundView: View {
    ///         var body: some View {
    ///             Text("Toolbar Background Example)
    ///                 .toolbarBackgroundPlus(opacity: 0.5)
    ///         }
    ///     }
    ///
    /// - Parameter opacity: Background Opacity of the navigation bar. Between 0 to 1.
    @ViewBuilder
    public func toolbarBackgroundPlus(opacity: CGFloat) -> some View {
        self
            .transformPreference(GeometryScrollOpacityPreferenceKey.self) {
                value in
                value = opacity
            }
    }


    /// Changes the maximum opacity of the background. While you use ``GeometryScrollView``
    /// it provides to the background some opacity value based on scroll. Use this to get a maximum amount
    /// you want.
    ///
    ///     struct ToolbarBackgroundView: View {
    ///         var body: some View {
    ///             GeometryScrollView {
    ///                VStack {
    ///                    ForEach(0..<10) { _ in
    ///                    Rectangle()
    ///                        .frame(height: 200)
    ///                    }
    ///                }
    ///             }
    ///                 .toolbarBackgroundPlus(maxOpacity: 0.5)
    ///         }
    ///     }
    ///
    /// - Parameter maxOpacity: Maximum opacity value the navigationBar background can have.
    public func toolbarBackgroundPlus(maxOpacity: CGFloat) -> some View {
        self
            .transformPreference(GeometryScrollOpacityPreferenceKey.self) {
                value in
                value = min(maxOpacity, value)
            }
    }


    /// Hides the navigation back button for the view.
    /// - Parameter isHidden: boolean value that can hide or show the back button.
    @ViewBuilder
    public func navigationBarBackButtonHiddenPlus(_ isHidden: Bool) -> some View
    {
        self
            .preference(
                key: ToolbarBackButtonDisabledPreferenceKey.self,
                value: isHidden)
    }


    /// By default if you use ``GeometryScrollView`` it will provide offset values a header can have.
    /// you can enable the same behaviour for the navigationBar. If you disable this. NavigationBar will not
    /// change it's position no matter the offset value given by the ``GeometryScrollView``.
    ///
    /// - Parameter isDisabled: A boolean value that indicates if navigation bar can scroll with
    /// ``GeometryScrollView`` or not.
    @ViewBuilder
    public func navigationBarScrollDisabledPlus(_ isDisabled: Bool) -> some View
    {
        self
            .preference(
                key: ToolbarScrollDisabledPreferenceKey.self, value: isDisabled)
    }
}

extension View {
    func injectNavControllerToEnvironment() -> some View {
        self
            .modifier(InjectNavgigationController())
    }
}

extension View {

    /// NavigationStack has a background by itself. If you want it to have a clear background or another
    /// color that you may choose, you can do with this one.
    /// - Parameter color: Color that will be applied as the navigationStack background color.
    public func navigationStackBackgroundColor(_ color: Color) -> some View {
        self
            .introspect(.navigationStack, on: .iOS(.v17...)) { stack in
                stack.viewControllers.forEach {
                    $0.view.backgroundColor = UIColor(color)
                }
            }
    }
}
