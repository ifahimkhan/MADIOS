//
//  PassingDataView.swift
//  MADIOS
//
//  Created by apple on 8/16/25.
//

import SwiftUI

struct PassingDataView: View{
    @State var enteredData:String = ""

    enum Field { case enteredData }
    @FocusState private var focusedField: Field?
    
    @StateObject var userData = UserData()

    
    func navigateTo<Destination: View>(destination: Destination, text: String) -> some View {
        NavigationLink(
            destination: destination,
            label: {
                Text(text)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
            }
        )
    }
    
    var body: some View{
        NavigationView {
            VStack(spacing: 16){
                TextField("Enter Number!",text: $enteredData)
                    .keyboardType(.decimalPad)
                    .focused($focusedField,equals:.enteredData)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                navigateTo(destination: InitializerView(readOnlyData: enteredData), text: "Passing data via initializer")
                
                navigateTo(destination: BindingView(count: $enteredData), text: "Passing Binding object")
                
                Divider()
                
                TextField("Enter Amount",text: $userData.amount)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                navigateTo(destination: ObservableView(userdata: userData), text: "Passing Observable object")
                
                navigateTo(destination: DeeplyNestedView().environmentObject(userData), text: "Passing Environment object")
                
                Spacer()
                                   
            }.padding()
        }
    }
}

struct PassingDataView_Preview: PreviewProvider{
    static var previews: some View{
        PassingDataView()
    }
}
