//
//  InitializerView.swift
//  MADIOS
//
//  Created by apple on 8/16/25.
//
import SwiftUI

struct InitializerView:View{
    let readOnlyData:String
    var body:some View{
        VStack(spacing: 16){
            Text("This is read only data value cannot be modified")
            Text(readOnlyData)
        }.padding()
    }
}

struct InitializerView_Preview:PreviewProvider{
    
    static var previews: some View{
        InitializerView(readOnlyData: "Fahim")
    }
}
