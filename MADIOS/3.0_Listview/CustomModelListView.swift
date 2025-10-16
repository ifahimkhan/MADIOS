//
//  CustomModelListView.swift
//  MADIOS
//
//  Created by apple on 10/14/25.
//


import SwiftUI

struct CustomModelListView: View {
    @State private var items = [
        Item(title: "Task 1", description: "Complete project"),
        Item(title: "Task 2", description: "Review code"),
        Item(title: "Task 3", description: "Update documentation")
    ]
    
    var body: some View {
        NavigationView {
            List(items) { item in
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.headline)
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Custom Model")
        }
    }
}
#Preview {
    CustomModelListView()
}
