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
            }.navigationTitle("MAD LAB IOS")
        }
    }
}

#Preview {
    ContentView()
}
