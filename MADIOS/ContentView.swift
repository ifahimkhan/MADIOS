//
//  ContentView.swift
//  MADIOS
//
//  Created by apple on 8/15/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: CalculatorView()){
                    Text("1. Basic Calculator")
                }
                NavigationLink(destination: PassingDataView()){
                    Text("2. Passing Data between Views")
                }
                NavigationLink(destination: MainListView()){
                    Text("3. Basic ListView Implementation")
                }
                NavigationLink(destination: WebViewExample()){
                    Text("4. WebView with Navigation")
                }
            }.navigationTitle("MAD LAB IOS")
        }
    }
}

#Preview {
    ContentView()
}
