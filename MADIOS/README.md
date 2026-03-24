# MADIOS - Mobile Application Development iOS

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0+-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

A comprehensive iOS development learning repository designed to help developers understand and learn iOS development faster through practical, hands-on examples.

## 📱 Features

### 1. Basic Calculator
Learn fundamental SwiftUI concepts including:
- UI components (Buttons, Text, VStack/HStack)
- State management with `@State`
- Event handling
- Basic arithmetic operations

### 2. Passing Data Between Views
Master data flow patterns in SwiftUI:
- **`@Binding`** - Two-way data flow for primitive types
- **`@ObservableObject`** - Shared state across multiple views
- When to use each pattern

### 3. ListView with Advanced Features
Comprehensive list management:
- Displaying data in lists
- **Swipe-to-delete** functionality
- **Drag-and-drop reordering**
- Custom row implementations
- Using `ForEach`, `.onDelete()`, and `.onMove()`

### 4. WebView Browser ✨
Full-featured in-app web browser demonstrating:
- URL input and validation
- Loading progress indicator
- Page loading states (loading/finished)
- Navigation controls (back, forward, reload, stop)
- **Swipe gesture navigation** (back to previous page)
- Real-time URL updates
- **WKWebView** integration with SwiftUI
- **UIViewRepresentable** protocol
- **Coordinator pattern**
- **Key-Value Observing (KVO)**
- **WKNavigationDelegate**
- MVVM architecture

## 🎯 Learning Objectives

By exploring this repository, you'll learn:

- ✅ SwiftUI fundamentals and layout
- ✅ State management patterns
- ✅ Data passing between views
- ✅ List views and data manipulation
- ✅ Integrating UIKit components in SwiftUI
- ✅ Delegation and protocol patterns
- ✅ Memory management and cleanup
- ✅ MVVM architecture
- ✅ KVO (Key-Value Observing)
- ✅ Navigation and routing

## 🚀 Getting Started

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0 or later
- Basic understanding of Swift

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/MADIOS.git
```

2. Open the project in Xcode:
```bash
cd MADIOS
open MADIOS.xcodeproj
```

3. Build and run the project (⌘R)

## 📖 How to Use This Repository

1. **Start with ContentView.swift** - This is the main navigation hub
2. **Explore each feature** - Tap on any example to see it in action
3. **Read the code** - Each file includes educational comments
4. **Experiment** - Modify the code and see what happens
5. **Build your own** - Use these examples as templates for your own projects

## 🏗️ Project Structure

```
MADIOS/
├── ContentView.swift              # Main navigation hub
├── CalculatorView.swift           # Basic calculator example
├── PassingDataView.swift          # Data passing demonstration
├── BindingView.swift              # @Binding example
├── UserData.swift                 # ObservableObject example
├── MainListView.swift             # ListView hub
├── SwipeToDeleteListView.swift    # Advanced list features
├── CustomRow.swift                # Custom list row
├── WebViewExample.swift           # WebView browser (NEW)
├── claude.md                      # Detailed project documentation
└── README.md                      # This file
```

## 💡 Code Highlights

### WebView Implementation

The WebView example demonstrates advanced iOS development concepts:

```swift
// UIViewRepresentable bridges UIKit to SwiftUI
struct WebViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true // ✅ Swipe navigation
        // ... KVO observers for progress tracking
        return webView
    }
    // ...
}
```

**Key Features:**
- 🌐 Load any webpage with URL validation
- 📊 Real-time loading progress bar
- ⬅️ Back/forward navigation with swipe gestures
- 🔄 Reload and stop loading controls
- 📍 Live URL updates in address bar

### MVVM Pattern

```swift
class WebViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var loadingProgress: Double = 0.0
    @Published var canGoBack = false
    @Published var canGoForward = false
    
    weak var webView: WKWebView?
    // ... navigation methods
}
```

## 🎓 Learning Path

**Beginner:**
1. Start with the Calculator to understand SwiftUI basics
2. Move to Passing Data to learn state management
3. Explore ListView for data handling

**Intermediate:**
4. Study the WebView example for UIKit integration
5. Understand the Coordinator pattern
6. Learn about KVO and delegation

**Advanced:**
- Modify examples to add new features
- Combine concepts from multiple examples
- Build your own features using these patterns

## 🔧 Technical Details

### WebView Technical Implementation

The WebView demonstrates several advanced concepts:

1. **UIViewRepresentable Protocol**: Bridges UIKit's WKWebView to SwiftUI
2. **Coordinator Pattern**: Handles delegate callbacks and observations
3. **Key-Value Observing (KVO)**: Monitors WebView properties in real-time
4. **WKNavigationDelegate**: Handles navigation lifecycle events
5. **Memory Management**: Properly removes observers to prevent leaks
6. **MVVM Architecture**: Separates concerns for maintainability

### Data Flow Patterns

```
┌─────────────────┐
│   @State        │ → Local view state
├─────────────────┤
│   @Binding      │ → Two-way data flow
├─────────────────┤
│ @StateObject    │ → Lifecycle owner
├─────────────────┤
│ @ObservedObject │ → Shared state
└─────────────────┘
```

## 🤝 Contributing

Contributions are welcome! If you'd like to add new examples or improve existing ones:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/NewExample`)
3. Commit your changes (`git commit -m 'Add new example: [Name]'`)
4. Push to the branch (`git push origin feature/NewExample`)
5. Open a Pull Request

### Contribution Guidelines:
- Follow existing code style and patterns
- Include educational comments
- Add navigation link to ContentView
- Update README.md and claude.md
- Test thoroughly on iOS simulator

## 📝 Planned Features

Future examples to be added:

- [ ] Networking with URLSession (API calls)
- [ ] JSON parsing and Codable
- [ ] Core Data / SwiftData persistence
- [ ] MapKit integration
- [ ] Camera and Photos
- [ ] UserDefaults storage
- [ ] Animations and transitions
- [ ] Custom views and shapes
- [ ] Push notifications
- [ ] Dark mode support
- [ ] Swift Concurrency (async/await)

## 📚 Resources

- [Apple SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Swift Programming Language](https://docs.swift.org/swift-book/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [WWDC Videos](https://developer.apple.com/videos/)

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

Created with ❤️ for the iOS development community

## 🙏 Acknowledgments

- Apple's SwiftUI team for the amazing framework
- The iOS developer community for inspiration and support

---

**Star ⭐ this repository if you find it helpful!**

**Questions or suggestions?** Open an issue or submit a pull request.

**Happy Learning! 🚀**
