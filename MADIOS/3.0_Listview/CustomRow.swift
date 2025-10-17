//
//  CustomRow.swift
//  MADIOS
//
//  Created by apple on 10/16/25.
//

import SwiftUI
struct CustomRow: View {
    @State private var items = [
        Item(title: "Task 1", description: "Complete project", isCompleted: true),
        Item(title: "Task 2", description: "Review code", isCompleted: false)
    ]
    
    var body: some View {
        NavigationView {
            List(items) { item in
                ItemRow(item: item)
            }
            .navigationTitle("Tasks")
        }
    }
}
#Preview {
    CustomRow()
}
