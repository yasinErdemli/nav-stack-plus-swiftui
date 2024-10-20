//
//  SwiftUIView.swift
//  
//
//  Created by Yasin Erdemli on 24/8/24.
//

import SwiftUI

struct CustomNavigationLink<Label: View, Destination: View>: View {
    let destination: Destination?
    let label: Label
    let value: AnyHashable?
    init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination()
        self.label = label()
        self.value = nil
    }
    var body: some View {
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

extension CustomNavigationLink where Destination == Never {
    init<P>(value: P?, @ViewBuilder label: () -> Label) where P: Hashable {
        self.value = value
        self.label = label()
        self.destination = nil
    }
    init<P>(_ titleKey: LocalizedStringKey, value: P?) where Label == Text, P: Hashable {
        self.label = .init(titleKey)
        self.value = value
        self.destination = nil
    }
    init<S, P>(_ title: S, value: P?) where Label == Text, S: StringProtocol, P: Hashable {
        self.label = .init(title)
        self.value = value
        self.destination = nil
    }
    init<P>(value: P?, @ViewBuilder label: () -> Label) where P: Decodable, P: Encodable, P: Hashable {
        self.value = value
        self.label = label()
        self.destination = nil
    }
    var body: some View {
        NavigationLink(value: value) {
            label
        }
    }
}

extension CustomNavigationLink where Label == Text {
    init(_ titleKey: LocalizedStringKey, @ViewBuilder destination: () -> Destination) {
        self.label = .init(titleKey)
        self.destination = destination()
        self.value = nil
    }

    var body: some View {
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
        @State private var opacity: CGFloat = 0
        var body: some View {
            CustomNavigationStack {
                List(1..<10) { number in
                    NavigationLink("Select \(number) ", value: number)
                        .listRowBackground(Rectangle().fill(.red))
                }
                .customToolbar {
                    CustomToolbarItem(placement: .leading) {
                        Text("Hello")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(.blue)
                    }

                    CustomToolbarItem(placement: .trailing) {
                        Text("Tarot")
                            .font(.largeTitle)
                    }
                    CustomToolbarItem(placement: .trailing) {
                        Text("Tarot")
                            .font(.largeTitle)
                    }
                }
                .customToolbarBackground {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                }
                .customNavigationDestination(for: Int.self) { _ in
                    GeometryScrollView {
                        ForEach(0..<20) { _ in
                            Rectangle()
                                .fill(.red)
                                .frame(height: 200)
                        }
                    }
                    .navigationTitle("world")
                    .customToolbarBackground {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                    }
                }
                .navigationTitle("hello")
            }
        }
    }
}
