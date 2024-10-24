//
//  File.swift
//
//
//  Created by Yasin Erdemli on 18/8/24.
//

import ScrollPlus
import SwiftUI

/// A view that displays a root view and enables you to present additional
/// views over the root view.
///
/// Don't forget to call the `createNavigation` method at the end to
/// call the stack as a view. This is needed because it is impossible to use
/// view body in different extensions even with different requirements.
/// This effectively uses a protocol to bypass it and you can get the needed
/// view with the help of a function.
///
/// Use a navigation stack to present a stack of views over a root view.
/// People can add views to the top of the stack by clicking or tapping a
/// ``NavigationLinkPlus``, and remove views using built-in, platform-appropriate
/// controls, like a Back button or a swipe gesture. The stack always displays
/// the most recently added view that hasn't been removed, and doesn't allow
/// the root view to be removed.
///
/// To create navigation links, associate a view with a data type by adding a
/// ``View/navigationDestinationPlus(for:destination:)`` modifier inside
/// the stack's view hierarchy. Then initialize a ``NavigationLinkPlus`` that
/// presents an instance of the same kind of data. The following stack displays
/// a `ParkDetails` view for navigation links that present data of type `Park`:
///
///     NavigationStackPlus {
///         GeometryScrollView {
///             VStack {
///                 ForEach(parks) { park in
///                     NavigationLinkPlus(park.name, value: park)
///                 }
///             }
///         }
///         .navigationDestinationPlus(for: Park.self) { park in
///             ParkDetails(park: park)
///         }
///     }
///     .createNavigation()
///
/// In this example, the ``GeometryScrollView`` acts as the root view and is always
/// present. Selecting a navigation link from the scroll view adds a `ParkDetails`
/// view to the stack, so that it covers the scroll view. Navigating back removes
/// the detail view and reveals the scroll view again. The system disables backward
/// navigation controls when the stack is empty and the root view, namely
/// the scroll view, is visible.
///
/// ### Manage navigation state
///
/// By default, a navigation stack manages state to keep track of the views on
/// the stack. However, your code can share control of the state by initializing
/// the stack with a binding to a collection of data values that you create.
/// The stack adds items to the collection as it adds views to the stack and
/// removes items when it removes views. For example, you can create a ``State``
/// property to manage the navigation for the park detail view:
///
///     @State private var presentedParks: [Park] = []
///
/// Initializing the state as an empty array indicates a stack with no views.
/// Provide a ``Binding`` to this state property using the dollar sign (`$`)
/// prefix when you create a stack using the ``init(path:root:)``
/// initializer:
///
///     NavigationStackPlus(path: $presentedParks) {
///         GeometryScrollView {
///             VStack {
///                 ForEach(parks) { park in
///                     NavigationLinkPlus(park.name, value: park)
///                 }
///             }
///         }
///         .navigationDestinationPlus(for: Park.self) { park in
///             ParkDetails(park: park)
///         }
///     }
///     .createNavigation()
///
/// Like before, when someone taps or clicks the navigation link for a
/// park, the stack displays the `ParkDetails` view using the associated park
/// data. However, now the stack also puts the park data in the `presentedParks`
/// array. Your code can observe this array to read the current stack state. It
/// can also modify the array to change the views on the stack. For example, you
/// can create a method that configures the stack with a specific set of parks:
///
///     func showParks() {
///         presentedParks = [Park("Yosemite"), Park("Sequoia")]
///     }
///
/// The `showParks` method replaces the stack's display with a view that shows
/// details for Sequoia, the last item in the new `presentedParks` array.
/// Navigating back from that view removes Sequoia from the array, which
/// reveals a view that shows details for Yosemite. Use a path to support
/// deep links, state restoration, or other kinds of programmatic navigation.
///
/// ### Navigate to different view types
///
/// To create a stack that can present more than one kind of view, you can add
/// multiple ``View/navigationDestinationPlus(for:destination:)`` modifiers
/// inside the stack's view hierarchy, with each modifier presenting a
/// different data type. The stack matches navigation links with navigation
/// destinations based on their respective data types.
///
/// To create a path for programmatic navigation that contains more than one
/// kind of data, you can use a ``NavigationPath`` instance as the path.
public struct NavigationStackPlus<Data, Root>: NavigationStackProtocol
where Root: View {
    
    public var pathBinding: Binding<Data> { _path }
    @Binding public var path: Data
    public let root: Root


    
    /// This is needed because it is impossible to use
    /// view body in different extensions even with different requirements.
    /// This effectively uses a protocol to bypass it and you can get the needed
    /// view with the help of a function.
    func createNavigation() -> some View {
        return returnView
    }
}

extension NavigationStackPlus
where
    Data: MutableCollection,
    Data: RandomAccessCollection,
    Data: RangeReplaceableCollection,
    Data.Element: Hashable
{

    /// Creates a navigation stack with homogeneous navigation state that you
    /// can control.
    ///
    /// If you don't need access to the navigation state, use ``init(root:)``.
    ///
    /// - Parameters:
    ///   - path: A ``Binding`` to the navigation state for this stack.
    ///   - root: The view to display when the stack is empty.
    public init(path: Binding<Data>, @ViewBuilder root: () -> Root) {
        self._path = path
        self.root = root()
    }

    /// This is needed because it is impossible to use
    /// view body in different extensions even with different requirements.
    /// This effectively uses a protocol to bypass it and you can get the needed
    /// view with the help of a function.
    func createNavigation() -> some View {
        return returnView
    }
}

extension NavigationStackPlus where Data == NavigationPath {

    /// Creates a navigation stack that manages its own navigation state.
    ///
    /// - Parameters:
    ///   - root: The view to display when the stack is empty.
    public init(@ViewBuilder root: () -> Root) {
        self.root = root()
        self._path = .constant(.init())
    }

    /// Creates a navigation stack with homogeneous navigation state that you
    /// can control.
    ///
    /// If you don't need access to the navigation state, use ``init(root:)``.
    ///
    /// - Parameters:
    ///   - path: A ``Binding`` to the navigation state for this stack.
    ///   - root: The view to display when the stack is empty.
    public init(path: Binding<Data>, @ViewBuilder root: () -> Root) {
        self._path = path
        self.root = root()
    }

    /// This is needed because it is impossible to use
    /// view body in different extensions even with different requirements.
    /// This effectively uses a protocol to bypass it and you can get the needed
    /// view with the help of a function.
    func createNavigation() -> some View {
        return returnView
    }
}

#Preview {
    return ExampleView()

    struct ExampleView: View {
        @State var path: [Int] = .init()
        var body: some View {
            NavigationStackPlus(path: $path) {
                ZStack {
                    Rectangle()
                        .fill(.blue)
                        .ignoresSafeArea()
                    GeometryScrollView {
                        LazyVStack {
                            ForEach(1..<55) { number in
                                Button {
                                    path.append(number)
                                    print(path)
                                } label: {
                                    LabeledContent(
                                        "Go To",
                                        value: number.formatted(.number)
                                    )
                                    .foregroundStyle(.white)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(.red, in: .rect(cornerRadius: 12))
                            .padding(.horizontal)
                        }
                    }
                    .navigationDestinationPlus(for: Int.self) { item in
                        TargetExampleView(number: item)
                    }
                }
                .navigationTitle("Cusom Nav Stack")
                .toolbarPlus {
                    ToolbarItemPlus(placement: .leading) {
                        Button(
                            "Profile", systemImage: "person.circle.fill",
                            action: {}
                        )
                        .font(.title)
                    }
                    ToolbarItemPlus(placement: .principal) {
                        Text("Custom Nav Stack")
                    }
                    ToolbarItemPlus(placement: .trailing) {
                        Button(
                            "More Options", systemImage: "ellipsis.circle.fill",
                            action: {}
                        )
                        .foregroundStyle(.purple)
                    }
                }
                .toolbarBackgroundPlus(maxOpacity: 0.9)
                .toolbarBackgroundPlus {
                    Rectangle()
                        .fill(.ultraThickMaterial)
                }
                .navigationBarScrollDisabledPlus(false)
            }.createNavigation()
        }
    }

    struct TargetExampleView: View {
        private let number: Int
        init(number: Int) {
            self.number = number
        }
        var body: some View {
            GeometryScrollView {
                ForEach(0..<20) { _ in
                    Rectangle()
                        .fill(.red)
                        .frame(height: 200)
                }
            }
            .navigationTitle("\(number)")
            .toolbarPlus {
                ToolbarItemPlus(placement: .principal) {
                    Text(number, format: .number)
                }
            }
            .toolbarBackgroundPlus {
                Rectangle()
                    .fill(.bar)
                    .ignoresSafeArea()
            }
        }
    }
}


