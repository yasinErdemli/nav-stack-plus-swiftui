NavigationStackPlus
===================

NavigationStackPlus provides extended functionality for SwiftUI's native NavigationStack with additional customization options. This package introduces a suite of modifiers that enhance navigation, toolbar customization, and background manipulation, enabling more granular control over SwiftUI applications' navigation stacks.

Features
--------

*   **Extended Navigation**: Add navigation destinations with more flexible configurations (`navigationDestinationPlus`).

*   **Custom Toolbars**: Add toolbars with custom layouts and styling options (`toolbarPlus`).

*   **Background Customization**: Change navigation stack backgrounds, including color, opacity, and scroll behavior (`toolbarBackgroundPlus`).

*   **Programmatic Navigation**: Dynamically control the presentation of views with binding (`navigationDestinationPlus(item:)`).

*   **Scrollable Navigation Bar**: Using with `GeometryScrollView` and `navigationBarScrollDisabledPlus(true)` makes the navigationBar scroll with the scroll content.

## Requirements
- iOS 17.0+
- Swift 6.0+
- SwiftUI framework

## Installation

### Swift Package Manager

1. In Xcode, select **File > Add Packages**.
2. Enter the GitHub repository URL: `https://github.com/yasinErdemli/nav-stack-plus-swiftui`.
3. Choose the library and click **Add Package**.


## NOTE
---
1. To be able to see the names of the previous navigation controllers, you need to use SwiftUI's dedicated `navigationTitle` modifier.
2. Since you can't use `body` of `View` protocol in extensions even with different `where` blocks, you need to call `createNavigation` modifier of the `NavigationStackPlus` right after the decleration. See below for example.

Usage
-----

`NavigationStackPlus` is designed to closely resemble the default SwiftUI implementation of the `NavigationStack`. If you know how to use the `NavigationStack`, you know how to use `NavigationStackPlus`. It can do all the `NavigationLink` and `.navigationDestination` navigation also with its own `NavigationLinkPlus` and `.navigationDestinationPlus` methods.

### 1\. Navigation Destination with a Data Type

To present views based on specific data types inside a NavigationStackPlus, use the navigationDestinationPlus(for:destination:) modifier. This allows you to associate different views with specific types of data.

```swift
NavigationStackPlus {
    GeometryScrollView {
        NavigationLink("Mint", value: Color.mint)
        NavigationLink("Pink", value: Color.pink)
        NavigationLink("Teal", value: Color.teal)
    }
    .navigationDestinationPlus(for: Color.self) { color in
        ColorDetail(color: color)
    }
}
.createNavigation()
```

### 2\. Navigation Destination with a Boolean Binding

You can programmatically present a destination view by binding a Boolean value using `navigationDestinationPlus(isPresented:destination:)`. The view will be presented when the bound value is true.

```swift
@State private var showDetails = false
NavigationStackPlus {
    VStack {
        Circle().fill(favoriteColor)
        Button("Show details") {
            showDetails = true
        }
    }
    .navigationDestinationPlus(isPresented: $showDetails) {
        ColorDetail(color: favoriteColor)
    }
}
.createNavigation()
```
### 3\. Navigation Destination with a Bound Item

Use `navigationDestinationPlus(item:destination:)` to present a view when an item of the associated type is non-nil. This works well for detail views in a master-detail layout.

```swift
@State private var colorShown: Color?
NavigationStackPlus {
    GeometryScrollView {
        Button("Mint") { colorShown = .mint }
        Button("Pink") { colorShown = .pink }
    }
    .navigationDestinationPlus(item: $colorShown) { color in
        ColorDetail(color: color)
    }
}
.createNavigation()
```
### 4\. Customizing the Toolbar

You can customize the navigation toolbar by adding `ToolbarItemPlus` views to the `toolbarPlus` modifier.

```swift
NavigationStackPlus {
    Text("Custom Navigation Stack")
        .toolbarPlus {
            ToolbarItemPlus(placement: .leading) {
                Button("Profile", systemImage: "person.circle.fill") { }
                    .font(.title)
            }
            ToolbarItemPlus(placement: .principal) {
                Text("Title")
            }
            ToolbarItemPlus(placement: .trailing) {
                Button("More Options", systemImage: "ellipsis.circle.fill") { }
                    .foregroundStyle(.purple)
            }
        }
}
.createNavigation()
```

### 5\. Customizing the Toolbar Background

The `toolbarBackgroundPlus` modifier allows you to change the background of the navigation bar with a custom view.

```swift
Text("Content")
    .toolbarBackgroundPlus {
        Rectangle()
          .fill(.red)
    }
}
```
### 6\. Adjusting Opacity of Toolbar Background

You can control the opacity of the toolbar background using `toolbarBackgroundPlus(opacity:)`.

```swift
Text("Content")
    .toolbarBackgroundPlus(opacity: 0.5)
```
### 7\. Back Button Visibility

Hide or show the navigation bar back button with `navigationBarBackButtonHiddenPlus`.

```swift
Text("Content")
    .navigationBarBackButtonHiddenPlus(true)
```

### 8\. Scrolling Behavior

Control whether the navigation bar scrolls with the content using `navigationBarScrollDisabledPlus`.

```swift
GeometryScrollView {
    VStack {
        ForEach(0..<10) { _ in
            Rectangle().frame(height: 200)
        }
    }
}
.navigationBarScrollDisabledPlus(true)
```
License
-------

This package is available under the MIT license. See the LICENSE file for more details.
