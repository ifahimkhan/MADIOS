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
            
            MenuItem(title: "Custom Row ListView", destination: AnyView(CustomRow())),
            
            MenuItem(title: "Swipe to delete ListView", destination: AnyView(SwipeToDeleteListView())),
            
            MenuItem(title: "Search ListView", destination: AnyView(SearchListView()))
        ]
     
    var body: some View {
        NavigationView {
            List(menuItems) { item in
                NavigationLink(destination: item.destination){
                    Text(item.title)
                }
            }
        }
    }
}
#Preview {
    MainListView()
}

