//
//  SwiftUIView.swift
//
//
//  Created by Yasin Erdemli on 24/8/24.
//

import ScrollPlus
import SwiftUI

struct CustomNavigationLink<Label: View, Destination: View>: View {
    let destination: Destination?
    let label: Label
    let value: AnyHashable?
    init(
        @ViewBuilder destination: () -> Destination,
        @ViewBuilder label: () -> Label
    ) {
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
    init<P>(_ titleKey: LocalizedStringKey, value: P?)
    where Label == Text, P: Hashable {
        self.label = .init(titleKey)
        self.value = value
        self.destination = nil
    }
    init<S, P>(_ title: S, value: P?)
    where Label == Text, S: StringProtocol, P: Hashable {
        self.label = .init(title)
        self.value = value
        self.destination = nil
    }
    init<P>(value: P?, @ViewBuilder label: () -> Label)
    where P: Decodable, P: Encodable, P: Hashable {
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
    init(
        _ titleKey: LocalizedStringKey,
        @ViewBuilder destination: () -> Destination
    ) {
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
        var body: some View {
            CustomNavigationStack {
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
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(.red, in: .rect(cornerRadius: 12))
                            .padding(.horizontal)
                        }
                    }
                    .contentMargins(.top, 16, for: .scrollContent)
                    .customNavigationDestination(for: Int.self) {
                            TargetExampleView(number: $0)
                    }
                }
                .navigationTitle("Custom Nav Stack")
                .customToolbar {
                    CustomToolbarItem(placement: .leading) {
                        Button(
                            "Profile", systemImage: "person.circle.fill",
                            action: {}
                        )
                        .font(.title)
                    }
                    CustomToolbarItem(placement: .principal) {
                        Text("Custom Nav Stack")
                    }
                    CustomToolbarItem(placement: .trailing) {
                        Button(
                            "More Options", systemImage: "ellipsis.circle.fill",
                            action: {}
                        )
                        .foregroundStyle(.purple)
                    }
                }
                .customToolbarScrollDisabled(true)
                .customToolbarBackground {
                    Rectangle()
                        .fill(.ultraThinMaterial)

                }
            }
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
            .customToolbar {
                CustomToolbarItem(placement: .principal) {
                    Text(number, format: .number)
                }
            }
            .customToolbarBackground {
                Rectangle()
                    .fill(.bar)
                    .ignoresSafeArea()
            }
        }
    }
}
