//
//  DeeplyNestedView.swift
//  MADIOS
//
//  Created by apple on 8/16/25.
//

import SwiftUI

struct DeeplyNestedView:View {
    @EnvironmentObject var userdata:UserData
    var body: some View {
        VStack(spacing: 16){
            Text("EnvironmentObject\n Use @EnvironmentObject to “inject” models into many unrelated or deeply nested views—very useful for shared or global state in the app.")
            
            Text("Amount is $\(userdata.amount)")
            
            Button("Add $100"){
                let amount = Double(userdata.amount) ?? 0
                userdata.amount = String(amount + 100)
            }
            NavigationView{
                NavigationLink(destination:SubView(), label: {Text("Open subview")})
            }
            
            
            Text("Global/shared model for many views: @EnvironmentObject.")
                      
            
        }
        
    }
}

struct DeeplyNested_Preview : PreviewProvider{
    static var previews: some View{
        DeeplyNestedView().environmentObject(UserData())
    }
}
