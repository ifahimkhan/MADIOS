//
//  ObservableView.swift
//  MADIOS
//
//  Created by apple on 8/16/25.
//

import SwiftUI

struct ObservableView:View {
    @ObservedObject var userdata:UserData
    var body: some View {
        VStack(spacing: 16){
            Text("Use @ObservedObject for reference-type models passed between adjacent views.")
            
            Text("Amount is $\(userdata.amount)")
            
            Button("Add $100"){
                let amount = Double(userdata.amount) ?? 0
                userdata.amount = String(amount + 100)
            }
            
            Text("Single shared model between parent/child: @ObservedObject.")
                      
            
        }
        
    }
}
