//
//  SwiftUIView.swift
//
//
//  Created by Yasin Erdemli on 24/8/24.
//

import ScrollPlus
import SwiftUI

/// A view that controls a navigation presentation.
///
/// People click or tap a navigation link to present a view inside a
/// ``NavigationStackPlus`` . You control the visual
/// appearance of the link by providing view content in the link's `label`
/// closure. For example, you can use a ``Label`` to display a link:
///
///     NavigationLinkPlus {
///         FolderDetail(id: workFolder.id)
///     } label: {
///         Label("Work Folder", systemImage: "folder")
///     }
///
/// For a link composed only of text, you can use one of the convenience
/// initializers that takes a string and creates a ``Text`` view for you:
///
///     NavigationLinkPlus("Work Folder") {
///         FolderDetail(id: workFolder.id)
///     }
///
/// ### Link to a destination view
///
/// You can perform navigation by initializing a link with a destination view
/// that you provide in the `destination` closure. For example, consider a
/// `ColorDetail` view that fills itself with a color:
///
///     struct ColorDetail: View {
///         var color: Color
///
///         var body: some View {
///             color
///                 .toolbarPlus {
///                     ToolbarItemPlus(alignment: .principal) {
///                         Text(color.description)
///                     }
///                 }
///         }
///     }
///
/// The following ``NavigationStackPlus`` presents three links to color detail
/// views:
///
///     NavigationStackPlus {
///         GeometryScrollView {
///             NavigationLinkPlus("Mint") { ColorDetail(color: .mint) }
///             NavigationLinkPlus("Pink") { ColorDetail(color: .pink) }
///             NavigationLinkPlus("Teal") { ColorDetail(color: .teal) }
///         }
///         .toolbarPlus {
///            ToolbarItemPlus(alignment: .principal) {
///                Text("Colors")
///            }
///         }
///     }
///
/// ### Create a presentation link
///
/// Alternatively, you can use a navigation link to perform navigation based
/// on a presented data value. To support this, use the
/// ``View/navigationDestinationPlus(for:destination:)`` view modifier
/// inside a navigation stack to associate a view with a kind of data, and
/// then present a value of that data type from a navigation link. The
/// following example reimplements the previous example as a series of
/// presentation links, as you can see, you just use SwiftUI's default NavigationLink with
/// value for this:
///
///     NavigationStackPlus {
///         GeometryScrollView {
///             NavigationLink("Mint", value: Color.mint)
///             NavigationLink("Pink", value: Color.pink)
///             NavigationLink("Teal", value: Color.teal)
///         }
///         .navigationDestinationPlus(for: Color.self) { color in
///             ColorDetail(color: color)
///         }
///        .toolbarPlus {
///           ToolbarItemPlus(alignment: .principal) {
///               Text("Colors")
///           }
///        }
///     }
///
/// Separating the view from the data facilitates programmatic navigation
/// because you can manage navigation state by recording the presented data.
///
/// ### Control a presentation link programmatically
///
/// To navigate programmatically, introduce a state variable that tracks the
/// items on a stack. For example, you can create an array of colors to
/// store the stack state from the previous example, and initialize it as
/// an empty array to start with an empty stack:
///
///     @State private var colors: [Color] = []
///
/// Then pass a ``Binding`` to the state to the navigation stack:
///
///     NavigationStackPlus(path: $colors) {
///         // ...
///     }
///
/// You can use the array to observe the current state of the stack. You can
/// also modify the array to change the contents of the stack. For example,
/// you can programmatically add ``ShapeStyle/blue`` to the array, and
/// navigation to a new color detail view using the following method:
///
///     func showBlue() {
///         colors.append(.blue)
///     }
///
public struct NavigationLinkPlus<Label: View, Destination: View>: View {
    public let destination: Destination
    public let label: Label

    /// Creates a navigation link that presents the destination view.
    /// - Parameters:
    ///   - destination: A view for the navigation link to present.
    ///   - label: A view builder to produce a label describing the `destination`
    ///    to present.
    public init(
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder label: () -> Label
    ) {
        self.destination = destination()
        self.label = label()
    }

    /// Creates a navigation link that presents the destination view.
    /// - Parameters:
    ///   - destination: A view for the navigation link to present.
    ///   - label: A view builder to produce a label describing the `destination`
    ///    to present.
    public init(
        destination: Destination,
        @ViewBuilder label: () -> Label
    ) {
        self.destination = destination
        self.label = label()
    }

    /// Creates a navigation link that presents a destination view, with a text label
    /// that the link generates from a localized string key.
    /// - Parameters:
    ///   - titleKey: A localized string key for creating a text label.
    ///   - destination: A view for the navigation link to present.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder destination: () -> Destination) where Label == Text {
        self.destination = destination()
        self.label = Text(titleKey)
    }

    /// Creates a navigation link that presents a destination view, with a text label
    /// that the link generates from a title string.
    /// - Parameters:
    ///   - title: A string for creating a text label.
    ///   - destination: A view for the navigation link to present.
    public init<S>(_ title: S, @ViewBuilder destination: () -> Destination) where S : StringProtocol, Label == Text {
        self.destination = destination()
        self.label = Text(title)
    }

    public var body: some View {
        NavigationLink {
            CustomNavigationHeaderContainerView {
                destination
            }
            .toolbar(.hidden, for: .navigationBar)
        } label: {
            label
        }
    }
}


#Preview {
    return ExampleView()
    struct ExampleView: View {
        var body: some View {
            NavigationStackPlus {
                Group {
                    GeometryScrollView {
                        VStack {
                            ForEach(1..<11) { number in
                                NavigationLink(value: number) {
                                    LabeledContent(
                                        "Go To",
                                        value: number.formatted(.number))
                                }
                                .foregroundStyle(.white)

                                NavigationLinkPlus {
                                    TargetExampleView(number: number)
                                } label: {
                                    LabeledContent(
                                        "Go To",
                                        value: number.formatted(.number))
                                }


                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(.red, in: .rect(cornerRadius: 12))
                            .padding(.horizontal)
                        }
                    }
                    .contentMargins(.top, 16, for: .scrollContent)
                    .navigationDestinationPlus(for: Int.self) {
                        TargetExampleView(number: $0)
                    }
                }

                .navigationTitle("Custom Nav Stack")
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
                .navigationBarScrollDisabledPlus(true)
                .toolbarBackgroundPlus {
                    Rectangle()
                        .fill(.ultraThinMaterial)

                }
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
