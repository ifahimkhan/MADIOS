//
//  InitializerView.swift
//  MADIOS
//
//  Created by apple on 8/16/25.
//
import SwiftUI

struct BindingView:View{
    @Binding var count:String
    var body:some View{
        VStack(spacing: 16){
            Text("If you need the destination to modify data and reflect it back in the source: Use this for shared primitive types or simple data.")
            Text("count value is \(count)")
            Button("Increment Count"){
                let doubleCount = Double(count) ?? 0
                count = String(doubleCount + 1)
            }
            .padding()
            .background(Color.accentColor)
            .foregroundColor(Color.white)
            .cornerRadius(8)
        }.padding()
    }
}

struct BindingView_Preview:PreviewProvider{
    @State static var previewCount = "10"
    
    static var previews: some View{
        BindingView(count: $previewCount)
    }
}
