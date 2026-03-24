# Quick Reference: WebView Implementation

## 🚀 Quick Start

To use the WebView in your own projects, follow these patterns:

## Basic WebView Setup

### 1. Create the ViewModel

```swift
import WebKit
import Combine

class WebViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var loadingProgress: Double = 0.0
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var currentURL: URL?
    
    weak var webView: WKWebView?
    
    func loadURL(_ urlString: String) {
        // Add URL validation logic
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView?.load(request)
    }
}
```

### 2. Create UIViewRepresentable

```swift
import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        // Add KVO observers
        webView.addObserver(context.coordinator, 
                          forKeyPath: #keyPath(WKWebView.estimatedProgress), 
                          options: .new, context: nil)
        
        viewModel.webView = webView
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        // Remove observers
        uiView.removeObserver(coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
}
```

### 3. Create Coordinator

```swift
extension WebViewRepresentable {
    class Coordinator: NSObject, WKNavigationDelegate {
        let viewModel: WebViewModel
        
        init(viewModel: WebViewModel) {
            self.viewModel = viewModel
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            viewModel.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            viewModel.isLoading = false
        }
        
        override func observeValue(forKeyPath keyPath: String?, 
                                  of object: Any?, 
                                  change: [NSKeyValueChangeKey : Any]?, 
                                  context: UnsafeMutableRawPointer?) {
            if keyPath == #keyPath(WKWebView.estimatedProgress) {
                if let webView = object as? WKWebView {
                    viewModel.loadingProgress = webView.estimatedProgress
                }
            }
        }
    }
}
```

### 4. Create SwiftUI View

```swift
struct WebViewExample: View {
    @StateObject private var viewModel = WebViewModel()
    @State private var urlString = "https://www.apple.com"
    
    var body: some View {
        VStack {
            // URL Input
            TextField("Enter URL", text: $urlString)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            // Loading Indicator
            if viewModel.isLoading {
                ProgressView(value: viewModel.loadingProgress)
            }
            
            // WebView
            WebViewRepresentable(viewModel: viewModel)
            
            // Navigation Controls
            HStack {
                Button("Back") { viewModel.webView?.goBack() }
                    .disabled(!viewModel.canGoBack)
                Button("Forward") { viewModel.webView?.goForward() }
                    .disabled(!viewModel.canGoForward)
            }
        }
        .onAppear {
            viewModel.loadURL(urlString)
        }
    }
}
```

## 🔑 Key Concepts

### UIViewRepresentable Protocol

Bridges UIKit views to SwiftUI:

```swift
protocol UIViewRepresentable {
    associatedtype UIViewType: UIView
    
    func makeUIView(context: Context) -> UIViewType
    func updateUIView(_ uiView: UIViewType, context: Context)
    static func dismantleUIView(_ uiView: UIViewType, coordinator: Coordinator)
}
```

### Coordinator Pattern

Handles delegation and callbacks:

```swift
func makeCoordinator() -> Coordinator {
    Coordinator(viewModel: viewModel)
}

class Coordinator: NSObject, WKNavigationDelegate {
    // Handle delegate methods
}
```

### Key-Value Observing (KVO)

Monitor property changes:

```swift
// Add observer
webView.addObserver(observer, forKeyPath: keyPath, options: .new, context: nil)

// Observe changes
override func observeValue(forKeyPath keyPath: String?, ...) {
    // Handle changes
}

// Remove observer (important!)
webView.removeObserver(observer, forKeyPath: keyPath)
```

## 📋 Common Patterns

### URL Validation

```swift
func loadURL(_ urlString: String) {
    var finalURLString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
    
    // Add scheme if missing
    if !finalURLString.hasPrefix("http://") && !finalURLString.hasPrefix("https://") {
        finalURLString = "https://" + finalURLString
    }
    
    guard let url = URL(string: finalURLString) else {
        print("Invalid URL")
        return
    }
    
    webView?.load(URLRequest(url: url))
}
```

### Navigation State Tracking

```swift
// Monitor these properties with KVO:
webView.canGoBack       // Bool
webView.canGoForward    // Bool
webView.estimatedProgress  // Double (0.0 to 1.0)
webView.url             // URL?
webView.title           // String?
```

### Enable Swipe Gestures

```swift
webView.allowsBackForwardNavigationGestures = true
```

### Handle Loading States

```swift
func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    // Page started loading
    isLoading = true
}

func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    // Page finished loading
    isLoading = false
}

func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    // Navigation failed
    isLoading = false
    print("Error: \(error.localizedDescription)")
}
```

## ⚠️ Common Pitfalls

### 1. Memory Leaks

**Problem**: Forgetting to remove KVO observers
```swift
// ❌ BAD - No cleanup
func makeUIView(context: Context) -> WKWebView {
    webView.addObserver(coordinator, forKeyPath: keyPath, ...)
    return webView
}
```

**Solution**: Always remove observers
```swift
// ✅ GOOD - Proper cleanup
static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
    uiView.removeObserver(coordinator, forKeyPath: keyPath)
}
```

### 2. Strong Reference Cycles

**Problem**: Strong reference to webView in ViewModel
```swift
// ❌ BAD
class WebViewModel: ObservableObject {
    var webView: WKWebView?  // Strong reference
}
```

**Solution**: Use weak reference
```swift
// ✅ GOOD
class WebViewModel: ObservableObject {
    weak var webView: WKWebView?  // Weak reference
}
```

### 3. Main Thread Updates

**Problem**: Updating UI from background thread
```swift
// ❌ BAD
override func observeValue(...) {
    viewModel.loadingProgress = webView.estimatedProgress
}
```

**Solution**: Dispatch to main thread
```swift
// ✅ GOOD
override func observeValue(...) {
    DispatchQueue.main.async {
        self.viewModel.loadingProgress = webView.estimatedProgress
    }
}
```

### 4. URL Scheme Handling

**Problem**: Not handling URLs without scheme
```swift
// ❌ BAD - Fails for "apple.com"
guard let url = URL(string: urlString) else { return }
```

**Solution**: Add scheme if missing
```swift
// ✅ GOOD - Handles "apple.com" → "https://apple.com"
if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
    urlString = "https://" + urlString
}
guard let url = URL(string: urlString) else { return }
```

## 🎯 Advanced Features

### JavaScript Execution

```swift
webView.evaluateJavaScript("document.title") { result, error in
    if let title = result as? String {
        print("Page title: \(title)")
    }
}
```

### Custom User Agent

```swift
webView.customUserAgent = "MyApp/1.0"
```

### Handle URL Schemes

```swift
func webView(_ webView: WKWebView, 
            decidePolicyFor navigationAction: WKNavigationAction, 
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
    if let url = navigationAction.request.url {
        if url.scheme == "myapp" {
            // Handle custom scheme
            decisionHandler(.cancel)
            return
        }
    }
    decisionHandler(.allow)
}
```

### Take Screenshot

```swift
webView.takeSnapshot(with: nil) { image, error in
    if let image = image {
        // Use the screenshot
    }
}
```

### Clear Cache

```swift
let dataStore = WKWebsiteDataStore.default()
let dataTypes = Set([WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])

dataStore.removeData(ofTypes: dataTypes, 
                    modifiedSince: Date.distantPast) {
    print("Cache cleared")
}
```

## 📱 Info.plist Requirements

If you need to load HTTP (non-HTTPS) content:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

Or for specific domains:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>example.com</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

## 🔗 Useful WKWebView Properties

```swift
webView.estimatedProgress          // 0.0 to 1.0
webView.isLoading                 // Bool
webView.canGoBack                 // Bool
webView.canGoForward              // Bool
webView.url                       // Current URL
webView.title                     // Page title
webView.backForwardList           // Navigation history
webView.allowsBackForwardNavigationGestures  // Enable swipe
webView.allowsLinkPreview         // Enable link previews
```

## 📚 Resources

- [WKWebView Documentation](https://developer.apple.com/documentation/webkit/wkwebview)
- [UIViewRepresentable](https://developer.apple.com/documentation/swiftui/uiviewrepresentable)
- [WKNavigationDelegate](https://developer.apple.com/documentation/webkit/wknavigationdelegate)
- [Key-Value Observing Guide](https://developer.apple.com/documentation/swift/cocoa-design-patterns/using-key-value-observing-in-swift)

## 💡 Tips

1. **Always remove KVO observers** to prevent memory leaks
2. **Use weak references** for WKWebView in ViewModels
3. **Update UI on main thread** when handling KVO callbacks
4. **Handle URL schemes** properly (add https:// if missing)
5. **Test on real devices** for accurate performance
6. **Enable swipe gestures** for better UX
7. **Track navigation state** for button enabling/disabling
8. **Show loading indicators** for better user feedback

---

**Need help?** Check the full implementation in `WebViewExample.swift`
