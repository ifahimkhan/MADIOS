//
//  SwipeToDeleteListView.swift
//  MADIOS
//
//  Created by apple on 10/16/25.
//
import SwiftUI

struct SwipeToDeleteListView : View{
    @State private var items = [
        Item(title: "Task 1", description: "Complete Project"),
        Item(title: "Task 2", description: "Review code"),
        Item(title: "Task 3", description: "Complete NDPs"),
    ]
    var body : some View {
        NavigationView{
            List{
                ForEach(items){ item in
                    VStack(alignment: .leading){
                        Text(item.title)
                            .font(.headline)
                        Text(item.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .onMove(perform: moveItem)
                .onDelete(perform: deleteItems)
                
            }
        }
    }
    
    func deleteItems(atOffsets offset:IndexSet){
        items.remove(atOffsets: offset)
    }
    func moveItem(at source:IndexSet,to destination: Int){
        items.move(fromOffsets: source, toOffset: destination)
    }
}
#Preview {
    SwipeToDeleteListView()
}
