//
//  ItemRow.swift
//  MADIOS
//
//  Created by apple on 10/16/25.
//
import SwiftUI

struct ItemRow: View {
    let item: Item
    
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isCompleted ? .green : .gray)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding(.vertical, 8)
    }
}
#Preview {
    let demo = Item(title: "Title",description: "description",isCompleted: false)
    ItemRow(item: demo)
}
