//
//  WebViewExample.swift
//  MADIOS
//
//  Created by apple on 3/24/26.
//

import SwiftUI
import WebKit

/// A SwiftUI wrapper for WKWebView with navigation controls, URL input, and loading indicator
struct WebViewExample: View {
    @StateObject private var viewModel = WebViewModel()
    @State private var urlString = "https://www.apple.com"
    @State private var isEditingURL = false
    
    var body: some View {
        VStack(spacing: 0) {
            // URL Input Bar
            HStack {
                TextField("Enter URL", text: $urlString, onCommit: {
                    viewModel.loadURL(urlString)
                    isEditingURL = false
                })
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .keyboardType(.URL)
                .disabled(viewModel.isLoading)
                
                Button(action: {
                    viewModel.loadURL(urlString)
                    isEditingURL = false
                }) {
                    Image(systemName: viewModel.isLoading ? "xmark.circle.fill" : "arrow.clockwise.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            
            // Loading Progress Bar
            if viewModel.isLoading {
                ProgressView(value: viewModel.loadingProgress)
                    .progressViewStyle(.linear)
                    .animation(.easeInOut, value: viewModel.loadingProgress)
            }
            
            // WebView
            WebViewRepresentable(viewModel: viewModel)
            
            // Navigation Controls
            HStack(spacing: 40) {
                Button(action: { viewModel.goBack() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                .disabled(!viewModel.canGoBack)
                
                Button(action: { viewModel.goForward() }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
                .disabled(!viewModel.canGoForward)
                
                Spacer()
                
                Button(action: { viewModel.reload() }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                }
                
                Button(action: { viewModel.stopLoading() }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                }
                .disabled(!viewModel.isLoading)
            }
            .padding()
            .background(Color(.systemGray6))
        }
        .navigationTitle("Web Browser")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadURL(urlString)
        }
        .onChange(of: viewModel.currentURL) { _, newURL in
            if let url = newURL {
                urlString = url.absoluteString
            }
        }
    }
}

/// ViewModel to manage WebView state and interactions
class WebViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var loadingProgress: Double = 0.0
    @Published var canGoBack = false
    @Published var canGoForward = false
    @Published var currentURL: URL?
    @Published var pageTitle: String?
    
    weak var webView: WKWebView?
    
    func loadURL(_ urlString: String) {
        var finalURLString = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Add https:// if no scheme is provided
        if !finalURLString.hasPrefix("http://") && !finalURLString.hasPrefix("https://") {
            finalURLString = "https://" + finalURLString
        }
        
        guard let url = URL(string: finalURLString) else {
            print("Invalid URL: \(finalURLString)")
            return
        }
        
        let request = URLRequest(url: url)
        webView?.load(request)
    }
    
    func goBack() {
        webView?.goBack()
    }
    
    func goForward() {
        webView?.goForward()
    }
    
    func reload() {
        webView?.reload()
    }
    
    func stopLoading() {
        webView?.stopLoading()
    }
}

/// UIViewRepresentable wrapper for WKWebView
struct WebViewRepresentable: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true // Enable swipe gestures
        
        // Observe loading progress
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        webView.addObserver(context.coordinator, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        
        viewModel.webView = webView
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No updates needed
    }
    
    static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        // Remove observers
        uiView.removeObserver(coordinator, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        uiView.removeObserver(coordinator, forKeyPath: #keyPath(WKWebView.canGoBack))
        uiView.removeObserver(coordinator, forKeyPath: #keyPath(WKWebView.canGoForward))
        uiView.removeObserver(coordinator, forKeyPath: #keyPath(WKWebView.url))
        uiView.removeObserver(coordinator, forKeyPath: #keyPath(WKWebView.title))
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let viewModel: WebViewModel
        
        init(viewModel: WebViewModel) {
            self.viewModel = viewModel
        }
        
        // MARK: - WKNavigationDelegate
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.viewModel.isLoading = true
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.viewModel.isLoading = false
                self.viewModel.loadingProgress = 1.0
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.viewModel.isLoading = false
                print("Navigation failed: \(error.localizedDescription)")
            }
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            DispatchQueue.main.async {
                self.viewModel.isLoading = false
                print("Provisional navigation failed: \(error.localizedDescription)")
            }
        }
        
        // MARK: - KVO
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            guard let webView = object as? WKWebView else { return }
            
            DispatchQueue.main.async {
                switch keyPath {
                case #keyPath(WKWebView.estimatedProgress):
                    self.viewModel.loadingProgress = webView.estimatedProgress
                case #keyPath(WKWebView.canGoBack):
                    self.viewModel.canGoBack = webView.canGoBack
                case #keyPath(WKWebView.canGoForward):
                    self.viewModel.canGoForward = webView.canGoForward
                case #keyPath(WKWebView.url):
                    self.viewModel.currentURL = webView.url
                case #keyPath(WKWebView.title):
                    self.viewModel.pageTitle = webView.title
                default:
                    break
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        WebViewExample()
    }
}
