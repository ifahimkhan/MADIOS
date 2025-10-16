//
//  MainListView.swift
//  MADIOS
//
//  Created by apple on 10/14/25.
//
import SwiftUI

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let destination: AnyView
}

struct MainListView: View {
    let menuItems = [
            MenuItem(title: "List with Custom Model", destination: AnyView(CustomModelListView())),
            MenuItem(title: "Profile", destination: AnyView(CustomModelListView())),
            MenuItem(title: "Settings", destination: AnyView(CustomModelListView()))
        ]
     
    var body: some View {
        NavigationView {
            List(menuItems) { item in
                NavigationLink(destination: item.destination){
                    Text(item.title)
                }
            }
            .navigationTitle("List implementation")
        }
    }
}
#Preview {
    MainListView()
}

