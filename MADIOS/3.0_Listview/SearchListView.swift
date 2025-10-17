//
//  SearchListView.swift
//  MADIOS
//
//  Created by apple on 10/16/25.
//
import SwiftUI
struct SearchListView: View{
    @State private var items=[
        Item(title: "Task 1", description: "Complete Project"),
        Item(title: "Task 2", description: "Code Review"),
        Item(title: "Task 3", description: "Complete NDPs"),
    ]
    @State var searchText = ""
    var filteredItems: [Item]{
        if searchText.isEmpty{
            return items
        }else{
            return items.filter{
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    var body: some View{
        NavigationView {
            List(filteredItems){
                item in
                ItemRow(item: item)
            }
            .searchable(text: $searchText,prompt: "search Tasks")
            .navigationTitle("Task")
        }
    }
}
#Preview {
    SearchListView()
}
