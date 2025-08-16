//
//  SubView.swift
//  MADIOS
//
//  Created by apple on 8/16/25.
//

import SwiftUI

struct SubView:View {
    @EnvironmentObject var userData:UserData
    var body: some View {
        VStack{
            Text("Amount is \(userData.amount)")
        }
    }
}

struct SubView_Preview: PreviewProvider{
    static var previews: some View{
        let userdata = UserData()
        userdata.amount = "100"
        return SubView().environmentObject(userdata)
    }
}
