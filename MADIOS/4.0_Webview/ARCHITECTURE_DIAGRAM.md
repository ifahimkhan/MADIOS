# WebView Architecture Diagram

## Component Flow

```
┌─────────────────────────────────────────────────────────────┐
│                     WebViewExample                          │
│                    (SwiftUI View)                           │
│                                                             │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ URL Input   │  │ Progress Bar │  │  Web Content │      │
│  │ TextField   │  │ ProgressView │  │  (WebView)   │      │
│  └─────────────┘  └──────────────┘  └──────────────┘      │
│                                                             │
│  ┌──────────────────────────────────────────────────┐      │
│  │         Navigation Controls (HStack)             │      │
│  │  [Back] [Forward]     [Reload] [Stop]           │      │
│  └──────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────┘
                         │
                         │ @StateObject
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    WebViewModel                             │
│                   (@ObservableObject)                       │
│                                                             │
│  @Published var isLoading: Bool                            │
│  @Published var loadingProgress: Double                    │
│  @Published var canGoBack: Bool                            │
│  @Published var canGoForward: Bool                         │
│  @Published var currentURL: URL?                           │
│  @Published var pageTitle: String?                         │
│                                                             │
│  weak var webView: WKWebView?  ← Weak reference!          │
│                                                             │
│  func loadURL(_ urlString: String)                         │
│  func goBack()                                             │
│  func goForward()                                          │
│  func reload()                                             │
│  func stopLoading()                                        │
└─────────────────────────────────────────────────────────────┘
                         │
                         │ @ObservedObject
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              WebViewRepresentable                           │
│           (UIViewRepresentable Protocol)                    │
│                                                             │
│  func makeCoordinator() -> Coordinator                     │
│  func makeUIView(context:) -> WKWebView                    │
│  func updateUIView(_:context:)                             │
│  static func dismantleUIView(_:coordinator:)               │
└─────────────────────────────────────────────────────────────┘
                         │
                         │ creates & manages
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      WKWebView                              │
│                      (UIKit)                                │
│                                                             │
│  Properties:                                                │
│    • estimatedProgress: Double                             │
│    • canGoBack: Bool                                       │
│    • canGoForward: Bool                                    │
│    • url: URL?                                             │
│    • title: String?                                        │
│    • isLoading: Bool                                       │
│                                                             │
│  Configuration:                                             │
│    • allowsBackForwardNavigationGestures = true           │
│    • navigationDelegate = coordinator                      │
│                                                             │
│  Methods:                                                   │
│    • load(_ request: URLRequest)                          │
│    • goBack()                                              │
│    • goForward()                                           │
│    • reload()                                              │
│    • stopLoading()                                         │
└─────────────────────────────────────────────────────────────┘
                         │
                         │ delegates to
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                     Coordinator                             │
│         (NSObject, WKNavigationDelegate)                    │
│                                                             │
│  let viewModel: WebViewModel                               │
│                                                             │
│  WKNavigationDelegate Methods:                             │
│    • didStartProvisionalNavigation                         │
│    • didFinish                                             │
│    • didFail                                               │
│    • didFailProvisionalNavigation                          │
│                                                             │
│  KVO Observer:                                              │
│    • observeValue(forKeyPath:...)                          │
│      ├─ estimatedProgress → loadingProgress               │
│      ├─ canGoBack → canGoBack                             │
│      ├─ canGoForward → canGoForward                       │
│      ├─ url → currentURL                                  │
│      └─ title → pageTitle                                 │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### User Interaction → WebView Loading

```
User enters URL
    ↓
TextField binding updates urlString (@State)
    ↓
User taps reload or presses return
    ↓
viewModel.loadURL(urlString) called
    ↓
URL validation & scheme addition
    ↓
webView?.load(URLRequest) called
    ↓
didStartProvisionalNavigation triggered
    ↓
isLoading = true (@Published)
    ↓
SwiftUI view updates (Progress bar appears)
    ↓
[Page loads...]
    ↓
estimatedProgress KVO updates (0.0 → 1.0)
    ↓
loadingProgress updated (@Published)
    ↓
Progress bar animates
    ↓
didFinish triggered
    ↓
isLoading = false (@Published)
    ↓
SwiftUI view updates (Progress bar disappears)
```

### Property Observation Flow (KVO)

```
WKWebView property changes
    ↓
observeValue(forKeyPath:...) called in Coordinator
    ↓
Check keyPath and extract new value
    ↓
DispatchQueue.main.async { ... }  ← Main thread!
    ↓
Update @Published property in ViewModel
    ↓
Combine notifies subscribers
    ↓
SwiftUI automatically re-renders view
    ↓
UI reflects new state
```

## Memory Management

### Strong vs Weak References

```
┌─────────────────────────────────────────────────────────────┐
│                  Reference Graph                            │
│                                                             │
│  WebViewExample (View)                                     │
│         │                                                   │
│         │ @StateObject (Strong)                            │
│         ▼                                                   │
│  WebViewModel (ObservableObject)                           │
│         │                                                   │
│         │ weak (Weak Reference - Prevents Cycle!)         │
│         ▼                                                   │
│  WKWebView (UIKit Object)                                  │
│         │                                                   │
│         │ navigationDelegate (Strong)                      │
│         ▼                                                   │
│  Coordinator (NSObject)                                    │
│         │                                                   │
│         │ let (Strong)                                     │
│         ▼                                                   │
│  WebViewModel (Same instance as above)                     │
│                                                             │
│  ⚠️ Without 'weak var webView', this would create a       │
│     reference cycle and cause a memory leak!              │
└─────────────────────────────────────────────────────────────┘
```

### Observer Lifecycle

```
makeUIView(context:) called
    ↓
Create WKWebView instance
    ↓
Add KVO observers
    webView.addObserver(coordinator, forKeyPath: keyPath, ...)
    ↓
[View is active, observations work]
    ↓
View is dismissed or replaced
    ↓
dismantleUIView(_:coordinator:) called
    ↓
Remove KVO observers  ← CRITICAL!
    webView.removeObserver(coordinator, forKeyPath: keyPath)
    ↓
Objects deallocated
    ↓
No memory leaks! ✅
```

## Thread Safety

### UI Updates Flow

```
┌───────────────────────────────────────────────────────────┐
│              Background Thread                            │
│                                                           │
│  WKWebView property changes                              │
│          ↓                                                │
│  observeValue(...) called                                │
│          ↓                                                │
│  Must dispatch to main thread! ⚠️                        │
└───────────────────────────────────────────────────────────┘
                    ↓
            DispatchQueue.main.async { ... }
                    ↓
┌───────────────────────────────────────────────────────────┐
│                Main Thread                                │
│                                                           │
│  Update @Published property                              │
│          ↓                                                │
│  Combine publishes change                                │
│          ↓                                                │
│  SwiftUI re-renders view                                 │
│          ↓                                                │
│  UI updates visible to user ✅                           │
└───────────────────────────────────────────────────────────┘
```

## Navigation State Machine

```
┌───────────────────────────────────────────────────────────┐
│                  Navigation States                        │
│                                                           │
│     ┌─────────┐                                          │
│     │ Initial │                                          │
│     └────┬────┘                                          │
│          │ loadURL()                                     │
│          ▼                                                │
│     ┌─────────┐                                          │
│     │ Loading │ ← reload()                               │
│     └────┬────┘                                          │
│          │ didFinish / didFail                           │
│          ▼                                                │
│     ┌─────────┐                                          │
│  ┌─→│ Loaded  │                                          │
│  │  └────┬────┘                                          │
│  │       │                                                │
│  │       ├─ goBack() → Load previous page               │
│  │       ├─ goForward() → Load next page                │
│  │       └─ loadURL() → New page                        │
│  │                                                        │
│  └─── All navigation methods can return to Loaded state  │
│                                                           │
│  Button States:                                           │
│    • Back: enabled when canGoBack == true                │
│    • Forward: enabled when canGoForward == true          │
│    • Reload: always enabled                              │
│    • Stop: enabled when isLoading == true                │
└───────────────────────────────────────────────────────────┘
```

## SwiftUI Property Wrappers

```
┌───────────────────────────────────────────────────────────┐
│              Property Wrapper Usage                       │
│                                                           │
│  WebViewExample (View):                                  │
│    @StateObject var viewModel = WebViewModel()          │
│    └─ Creates and owns the ViewModel instance           │
│       Persists across view updates                       │
│                                                           │
│    @State var urlString = "..."                          │
│    └─ Local view state                                   │
│       Re-renders view when changed                       │
│                                                           │
│  WebViewRepresentable:                                   │
│    @ObservedObject var viewModel: WebViewModel          │
│    └─ Observes existing ViewModel                       │
│       Doesn't own it (owned by parent view)             │
│                                                           │
│  WebViewModel:                                           │
│    @Published var isLoading: Bool                       │
│    @Published var loadingProgress: Double               │
│    └─ Combine publishers                                 │
│       Notify subscribers when value changes             │
└───────────────────────────────────────────────────────────┘
```

## Key Patterns Summary

1. **UIViewRepresentable**: Bridges UIKit → SwiftUI
2. **Coordinator**: Handles delegation & callbacks
3. **KVO**: Observes UIKit property changes
4. **MVVM**: Separates concerns (Model-View-ViewModel)
5. **Weak References**: Prevents memory leaks
6. **Main Thread Dispatch**: Ensures UI safety
7. **@Published**: Enables reactive updates
8. **State Management**: SwiftUI property wrappers

## Common Issues & Solutions

```
┌───────────────────────────────────────────────────────────┐
│  Issue: Memory Leak                                       │
│  Cause: Forgot to remove KVO observers                   │
│  Solution: Implement dismantleUIView() properly          │
└───────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────┐
│  Issue: UI doesn't update                                 │
│  Cause: Updating from background thread                  │
│  Solution: Use DispatchQueue.main.async { ... }          │
└───────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────┐
│  Issue: Retain cycle / Memory not released               │
│  Cause: Strong reference from ViewModel to WKWebView     │
│  Solution: Use 'weak var webView: WKWebView?'           │
└───────────────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────────────┐
│  Issue: URL without scheme doesn't load                  │
│  Cause: URL("apple.com") returns nil                     │
│  Solution: Add "https://" prefix if missing              │
└───────────────────────────────────────────────────────────┘
```

---

This diagram provides a comprehensive overview of the WebView architecture.
For implementation details, see WebViewExample.swift and WEBVIEW_QUICK_REFERENCE.md
