//
//  Item.swift
//  MADIOS
//
//  Created by apple on 10/14/25.
//

import Foundation


struct Item: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
}
